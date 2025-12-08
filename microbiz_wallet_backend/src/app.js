const express = require('express');
const cors = require('cors');

const authRoutes = require('./api/routes/auth');
const ledgerRoutes = require('./api/routes/ledger'); // Import new ledger routes
const invoicesRoutes = require('./api/routes/invoices');
const customersRoutes = require('./api/routes/customers');
const loansRoutes = require('./api/routes/loans');
const reconRoutes = require('./api/routes/recon');
const creditRoutes = require('./api/routes/credit');

const app = express();

// TODO: For production, configure CORS more securely.
// Example: cors({ origin: 'https://your-flutter-app-domain.com' })
app.use(cors());

app.use(express.json());

// --- API Routes ---
app.get('/', (req, res) => {
  res.status(200).json({ status: 'ok', message: 'Backend is running!' });
});

app.use('/api', authRoutes);
app.use('/api/ledger', ledgerRoutes); // Correctly mount ledger routes

app.use('/api', invoicesRoutes);
app.use('/api', customersRoutes);
app.use('/api', loansRoutes);
app.use('/api/recon', reconRoutes); // Correctly mount recon routes
app.use('/api', creditRoutes);

module.exports = app;