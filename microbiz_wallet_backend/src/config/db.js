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
  connectTimeout: 20000, // 20 seconds timeout for initial connection
};

// Only apply SSL settings in the production environment
if (process.env.NODE_ENV === 'production') {
  console.log('Production environment detected. Applying SSL configuration.');
  // This is a common configuration for cloud database providers like PlanetScale
  dbConfig.ssl = {
    rejectUnauthorized: true,
  };
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
