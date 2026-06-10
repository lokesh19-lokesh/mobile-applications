import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from 'jsr:@supabase/supabase-js@2'

console.log("process-order function initialized!")

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: { 'Access-Control-Allow-Origin': '*' } })
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
    )

    const { shirtId, rentalDays, deliveryAddress } = await req.json()

    // 1. Get the authenticated user
    const { data: { user }, error: userError } = await supabaseClient.auth.getUser()
    if (userError || !user) throw new Error('Unauthorized')

    // 2. Fetch the shirt to get the price
    const { data: shirt, error: shirtError } = await supabaseClient
      .from('shirts')
      .select('*')
      .eq('id', shirtId)
      .single()

    if (shirtError || !shirt) throw new Error('Shirt not found')
    if (!shirt.is_available) throw new Error('Shirt is currently unavailable')

    const totalPrice = shirt.price_per_day * rentalDays

    // 3. Create the order
    const { data: order, error: orderError } = await supabaseClient
      .from('orders')
      .insert({
        customer_id: user.id,
        shirt_id: shirt.id,
        rental_days: rentalDays,
        total_price: totalPrice,
        pickup_address: 'Warehouse A',
        delivery_address: deliveryAddress,
        status: 'pending'
      })
      .select()
      .single()

    if (orderError) throw orderError

    // 4. Update shirt availability
    await supabaseClient
      .from('shirts')
      .update({ is_available: false })
      .eq('id', shirt.id)

    return new Response(
      JSON.stringify(order),
      { headers: { "Content-Type": "application/json", 'Access-Control-Allow-Origin': '*' }, status: 200 }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { headers: { "Content-Type": "application/json", 'Access-Control-Allow-Origin': '*' }, status: 400 }
    )
  }
})
