const db = require('../config/db');

exports.getAllShirts = async (req, res) => {
  try {
    const result = await db.query("SELECT * FROM shirts ORDER BY created_at DESC");
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: 'Server error' });
  }
};

exports.addShirt = async (req, res) => {
  const { qr_code, name, size, condition_rating } = req.body;
  try {
    const result = await db.query(
      "INSERT INTO shirts (qr_code, name, size, condition_rating) VALUES ($1, $2, $3, $4) RETURNING *",
      [qr_code, name, size, condition_rating || 5.0]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: 'Failed to add shirt' });
  }
};

exports.updateShirtStatus = async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;
  try {
    const result = await db.query(
      "UPDATE shirts SET status = $1 WHERE id = $2 RETURNING *",
      [status, id]
    );
    if (result.rows.length === 0) return res.status(404).json({ error: 'Shirt not found' });
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: 'Failed to update shirt' });
  }
};
