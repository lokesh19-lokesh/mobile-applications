const express = require('express');
const { supabase } = require('../supabaseClient');
const router = express.Router();

// Middleware to extract auth token for auth-dependent actions
const authenticate = async (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'Unauthorized' });
  const { data: { user }, error } = await supabase.auth.getUser(token);
  if (error || !user) return res.status(401).json({ error: 'Unauthorized' });
  req.user = user;
  next();
};

// POST /api/v1/auth/send-otp
router.post('/send-otp', async (req, res) => {
  const { phone } = req.body;
  // Supabase primarily uses email for OTP out of the box unless Twilio is configured.
  // We'll simulate it by treating phone as an email address for the prototype (e.g., 9876543210@test.com)
  const email = phone.includes('@') ? phone : `${phone}@test.com`;
  
  const { data, error } = await supabase.auth.signInWithOtp({ email });
  if (error) return res.status(400).json({ error: error.message });
  res.json({ message: 'OTP sent successfully' });
});

// POST /api/v1/auth/verify-otp
router.post('/verify-otp', async (req, res) => {
  const { phone, otp } = req.body;
  const email = phone.includes('@') ? phone : `${phone}@test.com`;

  const { data, error } = await supabase.auth.verifyOtp({ email, token: otp, type: 'magiclink' });
  if (error) return res.status(400).json({ error: error.message });
  res.json({ token: data.session.access_token, user: data.user });
});

// POST /api/v1/auth/register
router.post('/register', async (req, res) => {
  const { phone, firstName, lastName, role } = req.body;
  const email = phone.includes('@') ? phone : `${phone}@test.com`;

  const { data, error } = await supabase.auth.signUp({
    email,
    password: 'SecurePassword123!', // Standardized for prototype
    options: {
      data: { full_name: `${firstName} ${lastName}`, role: role || 'CUSTOMER' }
    }
  });

  if (error) return res.status(400).json({ error: error.message });
  res.json({ message: 'Registration successful', user: data.user });
});

module.exports = { router, authenticate };
