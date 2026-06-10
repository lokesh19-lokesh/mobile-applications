const express = require('express');
const { supabase } = require('../supabaseClient');
const router = express.Router();

// GET /api/v1/shirts
router.get('/', async (req, res) => {
  const { category, size, color } = req.query;
  
  let query = supabase.from('shirts').select('*, shirt_inventory!inner(*)');
  
  // Filtering logic
  if (size) query = query.eq('shirt_inventory.size', size);
  if (color) query = query.ilike('shirt_inventory.color', `%${color}%`);
  // Note: Category requires joining with shirt_categories which we can do if needed, but omitted for brevity in simple text matching

  const { data, error } = await query;
  if (error) return res.status(400).json({ error: error.message });
  res.json(data);
});

// GET /api/v1/shirts/:id
router.get('/:id', async (req, res) => {
  const { data, error } = await supabase
    .from('shirts')
    .select('*, shirt_inventory(*)')
    .eq('id', req.params.id)
    .single();

  if (error) return res.status(400).json({ error: error.message });
  res.json(data);
});

// GET /api/v1/shirts/:id/availability
router.get('/:id/availability', async (req, res) => {
  const { startDate, endDate } = req.query;
  
  // This query checks if there are any available inventory items for the shirt
  // Real implementation would cross-check against active 'orders' dates.
  const { data, error } = await supabase
    .from('shirt_inventory')
    .select('*')
    .eq('shirt_id', req.params.id)
    .eq('status', 'AVAILABLE');

  if (error) return res.status(400).json({ error: error.message });
  
  const isAvailable = data.length > 0;
  res.json({ available: isAvailable, available_items: data.length });
});

module.exports = router;
