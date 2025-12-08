const express = require('express');
const router = express.Router();
const reconController = require('../controllers/reconController');
const verifyToken = require('../middleware/authMiddleware');

router.post('/sync', verifyToken, reconController.syncTransactions);
router.post('/reconcile', verifyToken, reconController.reconcileTransactions);

module.exports = router;