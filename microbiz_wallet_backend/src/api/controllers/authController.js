const { db } = require('../../config/index');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const register = (req, res) => {
  const { username, password, email } = req.body;

  // Hash password
  const salt = bcrypt.genSaltSync(10);
  const hashedPassword = bcrypt.hashSync(password, salt);

  const sql = 'INSERT INTO users (username, password, email) VALUES (?, ?, ?)';
  db.query(sql, [username, hashedPassword, email], (err, result) => {
    if (err) {
      if (err.code === 'ER_DUP_ENTRY') {
        return res.status(409).send('Username or email already exists');
      }
      console.error('Error registering user: ' + err.stack);
      return res.status(500).send('Error registering user');
    }
    res.status(201).send({ message: 'User registered successfully', userId: result.insertId });
  });
};

const login = (req, res) => {
  const { username, password } = req.body;

  const sql = 'SELECT * FROM users WHERE username = ?';
  db.query(sql, [username], (err, results) => {
    if (err) {
      console.error('Error logging in: ' + err.stack);
      return res.status(500).send('Error logging in');
    }
    if (results.length === 0) {
      return res.status(401).send('Invalid credentials');
    }

    const user = results[0];
    const passwordIsValid = bcrypt.compareSync(password, user.password);

    if (!passwordIsValid) {
      return res.status(401).send('Invalid credentials');
    }

    const token = jwt.sign({ id: user.id, username: user.username }, process.env.JWT_SECRET, {
      expiresIn: 86400 // 24 hours
    });

    res.status(200).send({
      auth: true,
      token: token,
      userId: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      dob: user.dob,
    });
  });
};

module.exports = {
  register,
  login,
};