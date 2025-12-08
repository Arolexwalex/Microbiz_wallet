const express = require('express');
const router = express.Router();
const creditController = require('../controllers/creditController');
const verifyToken = require('../middleware/authMiddleware');

router.get('/credit-score', verifyToken, creditController.getCreditScore);

module.exports = router;