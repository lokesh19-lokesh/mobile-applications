const express = require('express');
const { supabase } = require('../supabaseClient');
const { authenticate } = require('./auth');
const router = express.Router();

// Shared memory store for prototype cart
const userCarts = {};

router.use(authenticate);

// POST /api/v1/cart
router.post('/cart', (req, res) => {
  const { shirt_id, size, duration, start_date } = req.body;
  const userId = req.user.id;
  
  if (!userCarts[userId]) {
    userCarts[userId] = [];
  }
  
  const cartItem = { shirt_id, size, duration, start_date, added_at: new Date() };
  userCarts[userId].push(cartItem);
  
  res.json({ message: 'Item added to cart', cart: userCarts[userId] });
});

// POST /api/v1/orders/checkout
router.post('/checkout', async (req, res) => {
  const userId = req.user.id;
  const cart = userCarts[userId];

  if (!cart || cart.length === 0) {
    return res.status(400).json({ error: 'Cart is empty' });
  }

  // Find an available inventory item for the first cart item (simplified prototype logic)
  const cartItem = cart[0];
  const { data: inventoryData, error: invError } = await supabase
    .from('shirt_inventory')
    .select('id')
    .eq('shirt_id', cartItem.shirt_id)
    .eq('size', cartItem.size)
    .eq('status', 'AVAILABLE')
    .limit(1)
    .single();

  if (invError || !inventoryData) {
    return res.status(400).json({ error: 'Selected shirt is no longer available in this size' });
  }

  // Create order
  const { data: order, error: orderError } = await supabase
    .from('orders')
    .insert({
      user_id: userId,
      status: 'PENDING',
      total_amount: 1500, // Hardcoded for prototype, normally calculated
      shirt_inventory_id: inventoryData.id
    })
    .select()
    .single();

  if (orderError) return res.status(400).json({ error: orderError.message });

  // Update inventory status
  await supabase
    .from('shirt_inventory')
    .update({ status: 'RENTED' })
    .eq('id', inventoryData.id);

  // Clear cart
  delete userCarts[userId];

  res.json({ message: 'Checkout successful', order });
});

// GET /api/v1/orders
router.get('/', async (req, res) => {
  const { data, error } = await supabase
    .from('orders')
    .select('*, shirt_inventory(shirts(name))')
    .eq('user_id', req.user.id)
    .order('created_at', { ascending: false });

  if (error) return res.status(400).json({ error: error.message });
  res.json(data);
});

// GET /api/v1/orders/:id
router.get('/:id', async (req, res) => {
  const { data, error } = await supabase
    .from('orders')
    .select('*, shirt_inventory(*)')
    .eq('id', req.params.id)
    .eq('user_id', req.user.id)
    .single();

  if (error) return res.status(400).json({ error: error.message });
  res.json(data);
});

// POST /api/v1/orders/:id/return
router.post('/:id/return', async (req, res) => {
  const { data, error } = await supabase
    .from('orders')
    .update({ status: 'RETURN_REQUESTED' })
    .eq('id', req.params.id)
    .eq('user_id', req.user.id)
    .select()
    .single();

  if (error) return res.status(400).json({ error: error.message });
  res.json({ message: 'Return initiated', order: data });
});

module.exports = router;
