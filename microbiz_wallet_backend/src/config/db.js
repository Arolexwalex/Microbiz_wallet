const mysql = require('mysql2/promise');
require('dotenv').config();

const dbConfig = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  connectTimeout: 20000,
};

// Only apply SSL settings in the production environment
if (process.env.NODE_ENV === 'production') {
  console.log('Production environment detected. Applying SSL configuration.');
  dbConfig.ssl = {
    rejectUnauthorized: true,
  };
}

const pool = mysql.createPool(dbConfig); // This now returns a promise-based pool

// We can now export the pool directly. The promise-based nature of mysql2
// handles connection acquisition and release much more gracefully.

module.exports = pool;
