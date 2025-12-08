const express = require('express');
const router = express.Router();
const customersController = require('../controllers/customersController');
const verifyToken = require('../middleware/authMiddleware');

router.post('/customers', verifyToken, customersController.createCustomer);
router.get('/customers', verifyToken, customersController.getAllCustomers);
router.get('/customers/:id', verifyToken, customersController.getCustomerById);
router.put('/customers/:id', verifyToken, customersController.updateCustomer);
router.delete('/customers/:id', verifyToken, customersController.deleteCustomer);

module.exports = router;