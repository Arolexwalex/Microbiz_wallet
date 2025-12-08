const express = require('express');
const router = express.Router();
const { getCreditScore } = require('../controllers/creditScoreController');
const { verifyToken } = require('../middleware/authMiddleware');

// GET /api/credit-score
router.get('/', verifyToken, getCreditScore);
