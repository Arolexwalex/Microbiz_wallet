const db = require('../../config/db');

const getCreditScore = (req, res) => {
  const userId = req.userId;
  const sql = 'SELECT * FROM records WHERE userId = ? ORDER BY date DESC';
  
  db.query(sql, [userId], (err, results) => {
    if (err) return res.status(500).send('Error');
    const sales = results.filter(r => r.type === 'sale').reduce((sum, r) => sum + r.amountKobo, 0);
    const expenses = results.filter(r => r.type === 'expense').reduce((sum, r) => sum + r.amountKobo, 0);
    const profit = sales - expenses;
    const score = (profit > 0 ? 700 : 300) + results.length * 10; // Mock scale to 850
    res.status(200).json({ score });
  });
};

module.exports = { getCreditScore };