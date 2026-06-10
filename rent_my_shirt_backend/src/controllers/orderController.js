const db = require('../config/db');

exports.createOrder = async (req, res) => {
  const { user_id, shirt_id, rental_duration, total_amount } = req.body;
  try {
    const result = await db.query(
      "INSERT INTO orders (user_id, shirt_id, rental_duration, total_amount) VALUES ($1, $2, $3, $4) RETURNING *",
      [user_id, shirt_id, rental_duration, total_amount]
    );
    // Mark shirt as rented
    await db.query("UPDATE shirts SET status = 'rented' WHERE id = $1", [shirt_id]);
    
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: 'Failed to create order' });
  }
};

exports.getAllOrders = async (req, res) => {
  try {
    const result = await db.query(`
      SELECT o.*, u.name as customer_name, s.name as shirt_name 
      FROM orders o 
      JOIN users u ON o.user_id = u.id 
      JOIN shirts s ON o.shirt_id = s.id 
      ORDER BY o.created_at DESC
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: 'Server error' });
  }
};

exports.assignDriver = async (req, res) => {
  const { id } = req.params;
  const { driver_id } = req.body;
  try {
    const result = await db.query(
      "UPDATE orders SET driver_id = $1, status = 'out_for_delivery' WHERE id = $2 RETURNING *",
      [driver_id, id]
    );
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: 'Failed to assign driver' });
  }
};
