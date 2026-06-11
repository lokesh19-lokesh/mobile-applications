import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { Hono } from "https://deno.land/x/hono@v3.12.2/mod.ts"
import { createClient } from "npm:@supabase/supabase-js@2"

const app = new Hono()

// Middleware: CORS
app.use('*', async (c, next) => {
  c.res.headers.set('Access-Control-Allow-Origin', '*')
  c.res.headers.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
  c.res.headers.set('Access-Control-Allow-Headers', 'Content-Type, Authorization')
  if (c.req.method === 'OPTIONS') {
    return c.text('', 204)
  }
  await next()
})

// Middleware: Setup Supabase Client
app.use('*', async (c, next) => {
  const supabaseUrl = Deno.env.get('SUPABASE_URL') || 'https://viqpwrttemnajhjvxsqp.supabase.co'
  const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY') || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZpcXB3cnR0ZW1uYWpoanZ4c3FwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEwODc1NTIsImV4cCI6MjA5NjY2MzU1Mn0.nACZXJlEWoX0CoLlEr6XwmXY9ol9qwK9Q9-hKdgSVDs'
  
  c.set('supabase', createClient(supabaseUrl, supabaseKey))
  await next()
})

// Middleware: Require Auth (Used selectively on specific routes)
const requireAuth = async (c, next) => {
  const supabase = c.get('supabase')
  const authHeader = c.req.header('Authorization')
  if (!authHeader) return c.json({ error: 'Unauthorized' }, 401)
  
  const token = authHeader.replace('Bearer ', '')
  const { data: { user }, error } = await supabase.auth.getUser(token)
  
  if (error || !user) return c.json({ error: 'Unauthorized' }, 401)
  c.set('user', user)
  await next()
}

// ----------------------------------------------------
// AUTH API
// ----------------------------------------------------
app.post('/api/v1/auth/send-otp', async (c) => {
  const supabase = c.get('supabase')
  const { phone } = await c.req.json()
  const email = phone.includes('@') ? phone : `${phone}@test.com`

  const { error } = await supabase.auth.signInWithOtp({ email })
  if (error) return c.json({ error: error.message }, 400)
  return c.json({ message: 'OTP sent successfully' })
})

app.post('/api/v1/auth/verify-otp', async (c) => {
  const supabase = c.get('supabase')
  const { phone, otp } = await c.req.json()
  const email = phone.includes('@') ? phone : `${phone}@test.com`

  const { data, error } = await supabase.auth.verifyOtp({ email, token: otp, type: 'magiclink' })
  if (error) return c.json({ error: error.message }, 400)
  return c.json({ token: data.session.access_token, user: data.user })
})

app.post('/api/v1/auth/register', async (c) => {
  const supabase = c.get('supabase')
  const { phone, firstName, lastName, role } = await c.req.json()
  const email = phone.includes('@') ? phone : `${phone}@test.com`

  const { data, error } = await supabase.auth.signUp({
    email,
    password: 'SecurePassword123!',
    options: { data: { full_name: `${firstName} ${lastName}`, role: role || 'CUSTOMER' } }
  })
  if (error) return c.json({ error: error.message }, 400)
  return c.json({ message: 'Registration successful', user: data.user })
})

// ----------------------------------------------------
// USERS API
// ----------------------------------------------------
app.get('/api/v1/users/profile', requireAuth, async (c) => {
  const supabase = c.get('supabase')
  const user = c.get('user')
  const { data, error } = await supabase.from('customer_profiles').select('*').eq('user_id', user.id).single()
  if (error) return c.json({ error: error.message }, 400)
  return c.json(data)
})

app.put('/api/v1/users/profile', requireAuth, async (c) => {
  const supabase = c.get('supabase')
  const user = c.get('user')
  const updates = await c.req.json()
  const { data, error } = await supabase.from('customer_profiles').update(updates).eq('user_id', user.id).select().single()
  if (error) return c.json({ error: error.message }, 400)
  return c.json(data)
})

app.post('/api/v1/users/kyc', requireAuth, async (c) => {
  const supabase = c.get('supabase')
  const user = c.get('user')
  const { data, error } = await supabase.from('customer_profiles').update({ kyc_status: 'VERIFIED' }).eq('user_id', user.id).select().single()
  if (error) return c.json({ error: error.message }, 400)
  return c.json({ message: 'KYC documents uploaded successfully', profile: data })
})

// ----------------------------------------------------
// SHIRTS/INVENTORY API
// ----------------------------------------------------
app.get('/api/v1/shirts', async (c) => {
  const supabase = c.get('supabase')
  const size = c.req.query('size')
  const color = c.req.query('color')
  
  let query = supabase.from('shirts').select('*, shirt_inventory!inner(*)')
  if (size) query = query.eq('shirt_inventory.size', size)
  if (color) query = query.ilike('shirt_inventory.color', `%${color}%`)

  const { data, error } = await query
  if (error) return c.json({ error: error.message }, 400)
  return c.json(data)
})

app.get('/api/v1/shirts/:id', async (c) => {
  const supabase = c.get('supabase')
  const { data, error } = await supabase.from('shirts').select('*, shirt_inventory(*)').eq('id', c.req.param('id')).single()
  if (error) return c.json({ error: error.message }, 400)
  return c.json(data)
})

app.get('/api/v1/shirts/:id/availability', async (c) => {
  const supabase = c.get('supabase')
  const { data, error } = await supabase.from('shirt_inventory').select('*').eq('shirt_id', c.req.param('id')).eq('status', 'AVAILABLE')
  if (error) return c.json({ error: error.message }, 400)
  return c.json({ available: data.length > 0, available_items: data.length })
})

// ----------------------------------------------------
// ORDERS & CART API
// ----------------------------------------------------
// In-memory cart for Edge Functions is ephemeral and NOT recommended for production, 
// but we map the Express logic directly for this prototype.
const memoryCart = new Map()

app.post('/api/v1/cart', requireAuth, async (c) => {
  const user = c.get('user')
  const body = await c.req.json()
  
  if (!memoryCart.has(user.id)) memoryCart.set(user.id, [])
  memoryCart.get(user.id).push({ ...body, added_at: new Date() })
  
  return c.json({ message: 'Item added to cart', cart: memoryCart.get(user.id) })
})

app.post('/api/v1/orders/checkout', requireAuth, async (c) => {
  const supabase = c.get('supabase')
  const user = c.get('user')
  const cart = memoryCart.get(user.id)

  if (!cart || cart.length === 0) return c.json({ error: 'Cart is empty' }, 400)

  const cartItem = cart[0]
  const { data: inventoryData, error: invError } = await supabase
    .from('shirt_inventory').select('id')
    .eq('shirt_id', cartItem.shirt_id).eq('size', cartItem.size).eq('status', 'AVAILABLE')
    .limit(1).single()

  if (invError || !inventoryData) return c.json({ error: 'Selected shirt is no longer available in this size' }, 400)

  const { data: order, error: orderError } = await supabase
    .from('orders').insert({
      user_id: user.id,
      status: 'PENDING',
      total_amount: 1500, // Static prototype value
      shirt_inventory_id: inventoryData.id
    }).select().single()

  if (orderError) return c.json({ error: orderError.message }, 400)

  await supabase.from('shirt_inventory').update({ status: 'RENTED' }).eq('id', inventoryData.id)
  memoryCart.delete(user.id)

  return c.json({ message: 'Checkout successful', order })
})

app.get('/api/v1/orders', requireAuth, async (c) => {
  const supabase = c.get('supabase')
  const user = c.get('user')
  const { data, error } = await supabase.from('orders').select('*, shirt_inventory(shirts(name))').eq('user_id', user.id).order('created_at', { ascending: false })
  if (error) return c.json({ error: error.message }, 400)
  return c.json(data)
})

app.get('/api/v1/orders/:id', requireAuth, async (c) => {
  const supabase = c.get('supabase')
  const user = c.get('user')
  const { data, error } = await supabase.from('orders').select('*, shirt_inventory(*)').eq('id', c.req.param('id')).eq('user_id', user.id).single()
  if (error) return c.json({ error: error.message }, 400)
  return c.json(data)
})

app.post('/api/v1/orders/:id/return', requireAuth, async (c) => {
  const supabase = c.get('supabase')
  const user = c.get('user')
  const { data, error } = await supabase.from('orders').update({ status: 'RETURN_REQUESTED' }).eq('id', c.req.param('id')).eq('user_id', user.id).select().single()
  if (error) return c.json({ error: error.message }, 400)
  return c.json({ message: 'Return initiated', order: data })
})
// ----------------------------------------------------
// DRIVER API
// ----------------------------------------------------
app.get('/api/v1/driver/orders/available', requireAuth, async (c) => {
  const supabase = c.get('supabase')
  const { data, error } = await supabase.from('orders')
    .select('*, shirt_inventory(shirts(name))')
    .in('status', ['PENDING', 'RETURN_REQUESTED'])
    .order('created_at', { ascending: false })
    
  if (error) return c.json({ error: error.message }, 400)
  return c.json(data)
})

app.post('/api/v1/driver/orders/:id/accept', requireAuth, async (c) => {
  const supabase = c.get('supabase')
  const user = c.get('user')
  
  const { data: agent, error: agentError } = await supabase.from('delivery_agents').select('id').eq('user_id', user.id).single()
  if (agentError || !agent) return c.json({ error: 'Driver profile not found' }, 403)

  const { data, error } = await supabase.from('orders')
    .update({ delivery_agent_id: agent.id, status: 'ASSIGNED' })
    .eq('id', c.req.param('id'))
    .select().single()

  if (error) return c.json({ error: error.message }, 400)
  return c.json({ message: 'Order accepted', order: data })
})

app.post('/api/v1/driver/orders/:id/update-status', requireAuth, async (c) => {
  const supabase = c.get('supabase')
  const { status } = await c.req.json()
  
  const { data, error } = await supabase.from('orders')
    .update({ status })
    .eq('id', c.req.param('id'))
    .select().single()

  if (error) return c.json({ error: error.message }, 400)
  return c.json({ message: 'Order status updated', order: data })
})

app.post('/api/v1/driver/location', requireAuth, async (c) => {
  const supabase = c.get('supabase')
  const user = c.get('user')
  const { lat, lng } = await c.req.json()
  
  const { data, error } = await supabase.from('delivery_agents')
    .update({ current_lat: lat, current_lng: lng })
    .eq('user_id', user.id)
    .select().single()

  if (error) return c.json({ error: error.message }, 400)
  return c.json({ message: 'Location updated', agent: data })
})

serve(app.fetch)
