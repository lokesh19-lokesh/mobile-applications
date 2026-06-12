const { Client } = require('pg');

const connectionString = 'postgresql://postgres:Yestickainumber@1@db.viqpwrttemnajhjvxsqp.supabase.co:5432/postgres';

async function updateSchema() {
  const client = new Client({
    connectionString,
    ssl: { rejectUnauthorized: false }
  });

  try {
    await client.connect();
    console.log('Connected to Supabase PostgreSQL!');

    // Add plan columns to customer_profiles
    const alterQuery = `
      ALTER TABLE public.customer_profiles 
      ADD COLUMN IF NOT EXISTS plan_name VARCHAR DEFAULT 'Professional',
      ADD COLUMN IF NOT EXISTS plan_price DECIMAL DEFAULT 2499,
      ADD COLUMN IF NOT EXISTS plan_details VARCHAR DEFAULT '4 Shirts + 1 Tee';
    `;
    
    await client.query(alterQuery);
    console.log('Successfully added plan columns to customer_profiles.');
    
    // Update existing users to have the default plan for testing
    const updateQuery = `
      UPDATE public.customer_profiles 
      SET plan_name = 'Professional', plan_price = 2499, plan_details = '4 Shirts + 1 Tee'
      WHERE plan_name IS NULL;
    `;
    await client.query(updateQuery);
    console.log('Updated existing profiles with default plan.');

  } catch (err) {
    console.error('Error updating schema:', err);
  } finally {
    await client.end();
  }
}

updateSchema();
