const express = require('express');
const { supabase } = require('../supabaseClient');
const { authenticate } = require('./auth');
const router = express.Router();

router.use(authenticate);

// GET /api/v1/users/profile
router.get('/profile', async (req, res) => {
  const { data, error } = await supabase
    .from('customer_profiles')
    .select('*')
    .eq('user_id', req.user.id)
    .single();

  if (error) return res.status(400).json({ error: error.message });
  res.json(data);
});

// PUT /api/v1/users/profile
router.put('/profile', async (req, res) => {
  const updates = req.body;
  const { data, error } = await supabase
    .from('customer_profiles')
    .update(updates)
    .eq('user_id', req.user.id)
    .select()
    .single();

  if (error) return res.status(400).json({ error: error.message });
  res.json(data);
});

// POST /api/v1/users/kyc
router.post('/kyc', async (req, res) => {
  // In a real app, this handles multipart/form-data for file uploads
  // For the API definition, we stub it and update the status
  const { data, error } = await supabase
    .from('customer_profiles')
    .update({ kyc_status: 'VERIFIED' }) // Automatically verified for demo
    .eq('user_id', req.user.id)
    .select()
    .single();

  if (error) return res.status(400).json({ error: error.message });
  res.json({ message: 'KYC documents uploaded successfully', profile: data });
});

module.exports = router;
