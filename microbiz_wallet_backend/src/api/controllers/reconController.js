const db = require('../../config/db');

/**
 * Mocks fetching new transactions from a bank and storing them.
 */
const syncTransactions = (req, res) => {
  const userId = req.userId;
  console.log(`[Recon] Syncing mock bank transactions for user ${userId}...`);

  // In a real app, you'd fetch from a bank API. Here we insert mock data.
  const mockBankTransactions = [
    [userId, '2025-12-05', 150000, 'POS/FT/Vendor A'], // Matches a sale
    [userId, '2025-12-04', 25000, 'NEFT/Rent Payment'], // Unmatched expense
    [userId, '2025-12-03', 75000, 'Cash Deposit/Customer B'], // Unmatched income
  ];

  const deleteSql = 'DELETE FROM bank_transactions WHERE user_id = ?';
  const insertSql = 'INSERT INTO bank_transactions (user_id, date, amount_kobo, narration) VALUES ?';

  db.query(deleteSql, [userId], (err) => {
    if (err) {
      console.error('[Recon] Error clearing old bank transactions:', err);
      return res.status(500).json({ message: 'Failed to clear old transactions.' });
    }
    db.query(insertSql, [mockBankTransactions], (err) => {
      if (err) {
        console.error('[Recon] Error inserting mock bank transactions:', err);
        return res.status(500).json({ message: 'Failed to sync transactions.' });
      }
      res.status(200).json({ message: 'Mock bank transactions synced successfully.' });
    });
  });
};

/**
 * Finds bank transactions that don't have a matching ledger record.
 */
const reconcileTransactions = (req, res) => {
  const userId = req.userId;
  console.log(`[Recon] Starting reconciliation for user ${userId}...`);

  const sql = `
    SELECT bt.id, bt.date, bt.amount_kobo AS amountKobo, bt.narration
    FROM bank_transactions bt
    LEFT JOIN ledger_records lr ON bt.user_id = lr.user_id AND bt.amount_kobo = lr.amount_kobo
    WHERE bt.user_id = ? AND lr.id IS NULL
  `;

  db.query(sql, [userId], (err, unmatched) => {
    if (err) {
      console.error('[Recon] Error during reconciliation:', err);
      return res.status(500).json({ message: 'Reconciliation failed.' });
    }
    res.status(200).json({ message: 'Reconciliation complete', unmatched: unmatched });
  });
};

module.exports = { syncTransactions, reconcileTransactions };
