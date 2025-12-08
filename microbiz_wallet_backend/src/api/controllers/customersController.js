const db = require('../../config/db');

const createCustomer = (req, res) => {
  const userId = req.userId; // From JWT
  const { name, email, phone, address } = req.body;
  const sql = 'INSERT INTO customers (userId, name, email, phone, address) VALUES (?, ?, ?, ?, ?)';
  
  db.query(sql, [userId, name, email, phone, address], (err, result) => {
    if (err) {
      console.error('Error inserting customer: ' + err.stack);
      return res.status(500).json({ message: 'Error inserting customer' });
    }
    res.status(201).json({ message: 'Customer created successfully', id: result.insertId });
  });
};

const getAllCustomers = (req, res) => {
  const userId = req.userId;
  const sql = 'SELECT * FROM customers WHERE userId = ? ORDER BY name ASC';
  
  db.query(sql, [userId], (err, results) => {
    if (err) {
      console.error('Error fetching customers: ' + err.stack);
      return res.status(500).json({ message: 'Error fetching customers' });
    }
    res.status(200).json(results);
  });
};

const getCustomerById = (req, res) => {
  const userId = req.userId;
  const { id } = req.params;
  const sql = 'SELECT * FROM customers WHERE id = ? AND userId = ?';

  db.query(sql, [id, userId], (err, result) => {
    if (err) {
      console.error('Error fetching customer: ' + err.stack);
      return res.status(500).json({ message: 'Error fetching customer' });
    }
    if (result.length === 0) {
      return res.status(404).json({ message: 'Customer not found' });
    }
    res.status(200).json(result[0]);
  });
};

const updateCustomer = (req, res) => {
  const userId = req.userId;
  const { id } = req.params;
  const { name, email, phone, address } = req.body;
  const sql = 'UPDATE customers SET name = ?, email = ?, phone = ?, address = ? WHERE id = ? AND userId = ?';

  db.query(sql, [name, email, phone, address, id, userId], (err, result) => {
    if (err) {
      console.error('Error updating customer: ' + err.stack);
      return res.status(500).json({ message: 'Error updating customer' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Customer not found or not authorized' });
    }
    res.status(200).json({ message: 'Customer updated successfully' });
  });
};

const deleteCustomer = (req, res) => {
  const userId = req.userId;
  const { id } = req.params;
  const sql = 'DELETE FROM customers WHERE id = ? AND userId = ?';

  db.query(sql, [id, userId], (err, result) => {
    if (err) {
      console.error('Error deleting customer: ' + err.stack);
      return res.status(500).json({ message: 'Error deleting customer' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Customer not found or not authorized' });
    }
    res.status(200).json({ message: 'Customer deleted successfully' });
  });
};

module.exports = {
  createCustomer,
  getAllCustomers,
  getCustomerById,
  updateCustomer,
  deleteCustomer,
};