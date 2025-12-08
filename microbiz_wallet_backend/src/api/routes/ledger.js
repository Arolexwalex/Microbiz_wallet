const express = require('express');
const router = express.Router();
const recordsController = require('../controllers/recordsController');
const verifyToken = require('../middleware/authMiddleware'); // Import the shared middleware

// Apply token verification to all ledger routes
router.use(verifyToken);

// GET all ledger records for the authenticated user
router.get('/', recordsController.getAllRecords);

// POST a new ledger record
router.post('/', recordsController.createRecord);

// PUT (update) an existing ledger record
router.put('/:id', recordsController.updateRecord);

// DELETE a ledger record
router.delete('/:id', recordsController.deleteRecord);

module.exports = router;