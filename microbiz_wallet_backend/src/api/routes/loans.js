const express = require('express');
const router = express.Router();
const loansController = require('../controllers/loansController');
const verifyToken = require('../middleware/authMiddleware');

router.post('/loan-applications', verifyToken, loansController.createLoanApplication);
router.get('/loan-applications', verifyToken, loansController.getLoanApplications);

module.exports = router;