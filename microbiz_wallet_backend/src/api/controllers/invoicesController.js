const db = require('../../config/db');

const createInvoice = (req, res) => {
  const userId = req.userId;
  const { customerId, invoiceNumber, dateIssued, dueDate, totalAmount, status, items } = req.body;
  const itemsJson = JSON.stringify(items);
  const sql = 'INSERT INTO invoices (user_id, customerId, invoiceNumber, dateIssued, dueDate, amountKobo, status, items) VALUES (?, ?, ?, ?, ?, ?, ?, ?)';
  
  db.query(sql, [userId, customerId, invoiceNumber, dateIssued, dueDate, totalAmount * 100, status, itemsJson], (err, result) => {
    if (err) {
      // Enhanced error logging
      console.error('Error inserting invoice:', err);
      return res.status(500).json({
        message: 'Error inserting invoice.',
        error: err.sqlMessage || err.message // Send the specific SQL error back
      });
    }
    res.status(201).json({ message: 'Invoice created successfully', id: result.insertId });
  });
};

const getAllInvoices = (req, res) => {
  const userId = req.userId;
  // Use a JOIN to fetch customer details along with the invoice
  const sql = `
    SELECT i.*, c.name as customerName, c.email as customerEmail, c.phone as customerPhone 
    FROM invoices i
    LEFT JOIN customers c ON i.customerId = c.id
    WHERE i.user_id = ? ORDER BY i.dateIssued DESC
  `;
  db.query(sql, [userId], (err, results) => {
    if (err) {
      console.error('Error fetching invoices:', err);
      return res.status(500).json({ message: 'Error fetching invoices' });
    }
    const invoices = results.map(invoice => ({
      ...invoice,
      id: invoice.id.toString(), // Ensure ID is a string
      totalAmount: invoice.amountKobo / 100.0, // Convert kobo (int) to naira (double) and rename field
      // Ensure non-nullable string fields are not null
      customerName: invoice.customerName || 'No Customer',
      customerEmail: invoice.customerEmail || 'N/A',
      customerPhone: invoice.customerPhone || 'N/A',
      items: JSON.parse(invoice.items || '[]')
    }));
    res.status(200).json(invoices);
  });
};

const getInvoiceById = (req, res) => {
  const userId = req.userId;
  const { id } = req.params;
  // Use a JOIN to fetch customer details for a single invoice
  const sql = `
    SELECT i.*, c.name as customerName, c.email as customerEmail, c.phone as customerPhone 
    FROM invoices i
    LEFT JOIN customers c ON i.customerId = c.id
    WHERE i.id = ? AND i.user_id = ?
  `;
  db.query(sql, [id, userId], (err, result) => {
    if (err) {
      console.error('Error fetching invoice:', err);
      return res.status(500).json({ message: 'Error fetching invoice' });
    }
    if (result.length === 0) {
      return res.status(404).json({ message: 'Invoice not found' });
    }
    const invoice = {
      ...result[0],
      id: result[0].id.toString(), // Ensure ID is a string
      totalAmount: result[0].amountKobo / 100.0, // Convert kobo (int) to naira (double) and rename field
      // Add null-safe checks for customer details
      customerName: result[0].customerName || 'No Customer',
      customerEmail: result[0].customerEmail || 'N/A',
      customerPhone: result[0].customerPhone || 'N/A',
      items: JSON.parse(result[0].items || '[]')
    };
    res.status(200).json(invoice);
  });
};

const updateInvoice = (req, res) => {
  const userId = req.userId;
  const { id } = req.params;
  const { customerId, invoiceNumber, dateIssued, dueDate, totalAmount, status, items } = req.body;
  const itemsJson = JSON.stringify(items);
  const sql = 'UPDATE invoices SET customerId = ?, invoiceNumber = ?, dateIssued = ?, dueDate = ?, amountKobo = ?, status = ?, items = ? WHERE id = ? AND user_id = ?';

  db.query(sql, [customerId, invoiceNumber, dateIssued, dueDate, totalAmount * 100, status, itemsJson, id, userId], (err, result) => {
    if (err) {
      console.error('Error updating invoice:', err);
      return res.status(500).json({ message: 'Error updating invoice' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Invoice not found or not authorized' });
    }
    res.status(200).json({ message: 'Invoice updated successfully' });
  });
};

const deleteInvoice = (req, res) => {
  const userId = req.userId;
  const { id } = req.params;
  const sql = 'DELETE FROM invoices WHERE id = ? AND user_id = ?';

  db.query(sql, [id, userId], (err, result) => {
    if (err) {
      console.error('Error deleting invoice:', err);
      return res.status(500).json({ message: 'Error deleting invoice' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Invoice not found or not authorized' });
    }
    res.status(200).json({ message: 'Invoice deleted successfully' });
  });
};

module.exports = {
  createInvoice,
  getAllInvoices,
  getInvoiceById,
  updateInvoice,
  deleteInvoice,
};