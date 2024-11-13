// config/database.js
import mysql from "mysql2/promise"
import dotenv from "dotenv";

dotenv.config();

// Database configuration
const dbConfig = {
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "myapp",
  port: process.env.DB_PORT || 3306,

  // Connection pool settings
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,

  // Enable debug when needed
  debug: process.env.DB_DEBUG === "true" || false,

  // Automatically handle disconnects
  enableKeepAlive: true,
  keepAliveInitialDelay: 0,
};

// Create connection pool
const pool = mysql.createPool(dbConfig);

// Test the connection
async function testConnection() {
  try {
    const connection = await pool.getConnection();
    console.log("Database connected successfully");
    connection.release();
  } catch (error) {
    console.error("Error connecting to the database:", error.message);
    process.exit(1); // Exit if we can't connect to database
  }
}

// Helper function to execute queries
async function query(sql, params) {
  try {
    const [results] = await pool.execute(sql, params);
    return results;
  } catch (error) {
    console.error("Error executing query:", error.message);
    throw error;
  }
}

// Helper function for transactions
async function transaction(callback) {
  const connection = await pool.getConnection();
  await connection.beginTransaction();

  try {
    const result = await callback(connection);
    await connection.commit();
    return result;
  } catch (error) {
    await connection.rollback();
    throw error;
  } finally {
    connection.release();
  }
}

export { pool, query, transaction, testConnection };

// Usage example:
// import { pool, query, transaction, testConnection } from './config/database.js';
