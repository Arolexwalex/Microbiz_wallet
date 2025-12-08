const db = require('../../config/db');

const createLoanApplication = (req, res) => {
  const userId = req.userId;
  // Updated to match the Flutter model (camelCase)
  const { id, businessName, loanAmountRequested, purposeOfLoan, status, applicationDate } = req.body;
  
  // Validate required fields from the frontend
  if (!id || !businessName || !loanAmountRequested || !purposeOfLoan) {
    return res.status(400).json({ message: 'Missing required loan application fields.' });
  }

  const sql = 'INSERT INTO loan_applications (id, userId, businessName, loanAmountRequested, purposeOfLoan, status, applicationDate) VALUES (?, ?, ?, ?, ?, ?, ?)';
  
  db.query(sql, [id, userId, businessName, loanAmountRequested, purposeOfLoan, status, applicationDate], (err, result) => {
    if (err) {
      console.error('Error inserting loan application: ' + err.stack);
      return res.status(500).json({ message: 'Error inserting loan application', error: err.message });
    }
    res.status(201).json({ message: 'Loan application created successfully', id: id });
  });
};

const getLoanApplications = (req, res) => {
  const userId = req.userId;
  // Select specific columns to match the Flutter model
  const sql = 'SELECT id, businessName, loanAmountRequested, purposeOfLoan, status, applicationDate FROM loan_applications WHERE userId = ? ORDER BY applicationDate DESC';
  
  db.query(sql, [userId], (err, results) => {
    if (err) {
      console.error('Error fetching loan applications: ' + err.stack);
      return res.status(500).json({ message: 'Error fetching loan applications' });
    }

    // Ensure data format is consistent for the frontend
    const applications = results.map(app => ({
      id: app.id,
      businessName: app.businessName,
      loanAmountRequested: app.loanAmountRequested,
      purposeOfLoan: app.purposeOfLoan,
      status: app.status,
      applicationDate: new Date(app.applicationDate).toISOString(),
    }));

    res.status(200).json(applications);
  });
};

module.exports = {
  createLoanApplication,
  getLoanApplications,
};