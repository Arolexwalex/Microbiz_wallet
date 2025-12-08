const express = require('express');
const router = express.Router();
const invoicesController = require('../controllers/invoicesController');
const verifyToken = require('../middleware/authMiddleware');

router.post('/invoices', verifyToken, invoicesController.createInvoice);
router.get('/invoices', verifyToken, invoicesController.getAllInvoices);
router.get('/invoices/:id', verifyToken, invoicesController.getInvoiceById);
router.put('/invoices/:id', verifyToken, invoicesController.updateInvoice);
router.delete('/invoices/:id', verifyToken, invoicesController.deleteInvoice);

module.exports = router;