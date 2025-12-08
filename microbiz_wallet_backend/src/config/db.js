const mysql = require('mysql');
require('dotenv').config();
const fs = require('fs');
const path = require('path');

const dbConfig = {
  connectionLimit: 10,
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
};

// Only apply SSL settings in the production environment
if (process.env.NODE_ENV === 'production') {
  const caPath = path.join(__dirname, 'ca.pem');
  if (fs.existsSync(caPath)) {
    console.log('Found ca.pem, applying CA certificate for SSL.');
    dbConfig.ssl = {
      ca: fs.readFileSync(caPath),
    };
  } else {
    console.log('ca.pem not found, falling back to default SSL verification.');
    dbConfig.ssl = {
      rejectUnauthorized: true,
    };
  }
}

const pool = mysql.createPool(dbConfig);

pool.getConnection((err, connection) => {
  if (err) {
    console.error('Database connection failed:', err);
    return;
  }
  console.log('Connected to database.');
  connection.release();
});

module.exports = pool;
