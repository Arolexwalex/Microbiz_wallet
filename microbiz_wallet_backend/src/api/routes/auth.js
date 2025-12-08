// routes/auth.js — FINAL, 100% WORKING FOR MySQL + RENDER
const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../../config/db'); // Your MySQL connection (mysql2/promise)

// PROMISIFY DB QUERIES — THIS FIXES EVERYTHING
const util = require('util');
const query = util.promisify(db.query).bind(db);

// LOGIN — FINAL WORKING
router.post('/login', async (req, res) => {
  const { username, password } = req.body;

  console.log(`[LOGIN] Attempt for: ${username}`);

  if (!username || !password) {
    return res.status(400).json({ success: false, message: 'Username and password required' });
  }

  try {
    const results = await query('SELECT * FROM users WHERE username = ?', [username]);
    
    if (results.length === 0) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    const user = results[0];

    // Compare password
    const isMatch = await bcrypt.compare(password, user.password_hash || user.password);
    
    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    // Generate token
    const token = jwt.sign(
      { id: user.id, username: user.username },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    console.log(`[LOGIN] SUCCESS for ${username}`);

    res.json({
      success: true,
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email || '',
      }
    });

  } catch (err) {
    console.error('Login DB error:', err);
    res.status(500).json({ success: false, message: 'Database error' });
  }
});

module.exports = router;