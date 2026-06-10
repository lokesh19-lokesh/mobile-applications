const db = require('../config/db');
const jwt = require('jsonwebtoken');

const generateOTP = () => Math.floor(100000 + Math.random() * 900000).toString();

exports.login = async (req, res) => {
  const { phone } = req.body;
  if (!phone) return res.status(400).json({ error: 'Phone number is required' });

  try {
    // In a real app, send OTP via SMS. Here we just mock it.
    const otp = generateOTP();
    console.log(`Mock OTP for ${phone}: ${otp}`);

    res.json({ message: 'OTP sent successfully', phone, mockOtp: otp });
  } catch (err) {
    res.status(500).json({ error: 'Server error' });
  }
};

exports.verifyOTP = async (req, res) => {
  const { phone, otp, name, role } = req.body;

  try {
    // Mock verify
    if (otp !== '123456' && otp.length !== 6) {
      return res.status(400).json({ error: 'Invalid OTP' });
    }

    let result = await db.query('SELECT * FROM users WHERE phone = $1', [phone]);
    let user = result.rows[0];

    if (!user) {
      // Create new user if they don't exist
      result = await db.query(
        'INSERT INTO users (name, phone, role) VALUES ($1, $2, $3) RETURNING *',
        [name || 'New User', phone, role || 'customer']
      );
      user = result.rows[0];
    }

    const token = jwt.sign({ id: user.id, role: user.role }, process.env.JWT_SECRET, { expiresIn: '30d' });

    res.json({ message: 'Login successful', token, user });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
};
