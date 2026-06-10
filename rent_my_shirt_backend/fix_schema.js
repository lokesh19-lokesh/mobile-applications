const { Client } = require('pg');

const connectionString = 'postgresql://postgres:Yestickainumber@1@db.viqpwrttemnajhjvxsqp.supabase.co:5432/postgres';

const client = new Client({
  connectionString: connectionString,
});

async function run() {
  try {
    await client.connect();
    
    const query = `
      ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS shirt_inventory_id UUID REFERENCES public.shirt_inventory(id);

      -- Insert a mock order
      INSERT INTO public.orders (id, user_id, status, total_amount, shirt_inventory_id)
      SELECT 
        '55555555-5555-5555-5555-555555555555'::uuid, 
        id, 
        'PENDING', 
        499.00, 
        (SELECT id FROM public.shirt_inventory LIMIT 1)
      FROM public.users LIMIT 1
      ON CONFLICT DO NOTHING;
    `;

    await client.query(query);
    console.log('Fixed schema by adding shirt_inventory_id to orders');
  } catch (error) {
    console.error('Error executing query:', error);
  } finally {
    await client.end();
  }
}

run();
