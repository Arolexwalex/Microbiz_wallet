const db = require('../../config/db');

// Create Record (Sales or Expenses)
const createRecord = (req, res) => {
  const { title, amount, date, category = 'General', note = '', type } = req.body; // Frontend sends 'amount' in Naira
  const userId = req.userId;
  const amountKobo = Math.round(amount * 100); // Convert to kobo

  const sql = `
    INSERT INTO ledger_records (user_id, title, amount_kobo, date, category, note, type)
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(sql, [userId, title, amountKobo, date, category, note, type], (err, result) => {
    if (err) {
      console.error('Create record error:', err);
      return res.status(500).json({ message: 'Server error', error: err.message });
    }
    res.status(201).json({ message: 'Record created', id: result.insertId });
  });
};

// Get All Records (for Dashboard)
const getAllRecords = (req, res) => {
  const userId = req.userId;

  const sql = `
    SELECT id, title, amount_kobo AS amountKobo, date, category, note, type
    FROM ledger_records 
    WHERE user_id = ? 
    ORDER BY date DESC LIMIT 100
  `;

  db.query(sql, [userId], (err, rows) => {
    if (err) {
      console.error('Get records error:', err);
      return res.status(500).json({ message: 'Server error' });
    }
    res.json(rows);
  });
};

const updateRecord = (req, res) => {
  const { id } = req.params;
  const { title, amount, date, category, note, type } = req.body;
  const userId = req.userId;
  const amountKobo = Math.round(amount * 100);

  const sql = `
    UPDATE ledger_records
    SET title = ?, amount_kobo = ?, date = ?, category = ?, note = ?, type = ?
    WHERE id = ? AND user_id = ?
  `;

  db.query(sql, [title, amountKobo, date, category, note, type, id, userId], (err, result) => {
    if (err) {
      console.error('Update record error:', err);
      return res.status(500).json({ message: 'Server error', error: err.message });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Record not found or user not authorized.' });
    }
    res.json({ message: 'Record updated successfully' });
  });
};

const deleteRecord = (req, res) => {
  const { id } = req.params;
  const userId = req.userId;

  const sql = 'DELETE FROM ledger_records WHERE id = ? AND user_id = ?';

  db.query(sql, [id, userId], (err, result) => {
    if (err) {
      console.error('Delete record error:', err);
      return res.status(500).json({ message: 'Server error', error: err.message });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Record not found or user not authorized.' });
    }
    res.json({ message: 'Record deleted successfully' });
  });
};

module.exports = { createRecord, getAllRecords, updateRecord, deleteRecord };