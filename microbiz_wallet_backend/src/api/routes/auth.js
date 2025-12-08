const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../../config/db'); // Correct path to db config

// --- Register a new user ---
router.post('/register', async (req, res) => {
  const { username, email, password } = req.body;

  if (!username || !email || !password) {
    return res.status(400).json({ success: false, message: 'Please provide username, email, and password.' });
  }

  try {
    // INSECURE: Storing plain text password for debugging.
    // const hashedPassword = await bcrypt.hash(password, 10);
    const newUser = { username, email, password: password };
    const query = 'INSERT INTO users SET ?';

    db.query(query, newUser, (err, result) => {
      if (err) {
        if (err.code === 'ER_DUP_ENTRY') {
          return res.status(409).json({ success: false, message: 'Username or email already exists.' });
        }
        return res.status(500).json({ success: false, message: 'Database error during registration.' });
      }
      res.status(201).json({ success: true, message: 'User registered successfully!' });
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error during registration.' });
  }
});

// --- Login a user ---
router.post('/login', async (req, res) => {
  const { username, password } = req.body;
  
  // --- THIS IS THE DEBUGGING LOG ---
  console.log(`\n[AUTH.JS - DEBUG] Login attempt for user: "${username}" with password: "${password}" at ${new Date().toLocaleTimeString()}`);

  if (!username || !password) {
    return res.status(400).json({ success: false, message: 'Please provide username and password.' });
  }

  try {
    const query = 'SELECT * FROM users WHERE username = ?';
    db.query(query, [username], async (err, results) => {
      if (err) {
        return res.status(500).json({ success: false, message: 'Database query failed.' });
      }
      if (results.length === 0) {
        return res.status(401).json({ success: false, message: 'Invalid credentials.' });
      }

      const user = results[0];
      console.log(`[AUTH.JS - DEBUG] User found in DB. Comparing passwords...`);
      console.log(`[AUTH.JS - DEBUG] App Password: "${password}" (Type: ${typeof password})`);
      console.log(`[AUTH.JS - DEBUG] DB Password:   "${user.password}" (Type: ${typeof user.password})`);
      // INSECURE: Comparing plain text passwords for debugging.
      const isMatch = (password === user.password);

      if (!isMatch) {
        return res.status(401).json({ success: false, message: 'Invalid credentials.' });
      }

      const token = jwt.sign({ id: user.id, username: user.username }, process.env.JWT_SECRET, { expiresIn: '1h' });
      res.json({ success: true, token, userId: user.id, name: user.username, email: user.email });
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Server error during login.' });
  }
});

module.exports = router;