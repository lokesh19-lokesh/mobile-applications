const db = require('./db');

const initDB = async () => {
  try {
    // Users table
    await db.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        phone VARCHAR(20) UNIQUE NOT NULL,
        role VARCHAR(20) DEFAULT 'customer', -- 'customer', 'driver', 'admin'
        deposit_paid BOOLEAN DEFAULT false,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    // Inventory (Shirts) table
    await db.query(`
      CREATE TABLE IF NOT EXISTS shirts (
        id SERIAL PRIMARY KEY,
        qr_code VARCHAR(50) UNIQUE NOT NULL,
        name VARCHAR(100) NOT NULL,
        size VARCHAR(10) NOT NULL,
        condition_rating DECIMAL(3,2) DEFAULT 5.00,
        status VARCHAR(20) DEFAULT 'available', -- 'available', 'rented', 'laundry'
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    // Orders table
    await db.query(`
      CREATE TABLE IF NOT EXISTS orders (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id),
        shirt_id INTEGER REFERENCES shirts(id),
        driver_id INTEGER REFERENCES users(id),
        rental_duration VARCHAR(20) NOT NULL, -- '1 Day', '1 Week', '1 Month'
        total_amount DECIMAL(10,2) NOT NULL,
        status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'out_for_delivery', 'delivered', 'returned'
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    console.log("Database tables initialized successfully!");
  } catch (error) {
    console.error("Error initializing database:", error);
  }
};

initDB();
