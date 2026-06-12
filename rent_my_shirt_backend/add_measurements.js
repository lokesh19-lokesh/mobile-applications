const { Client } = require('pg');
const connectionString = 'postgresql://postgres:Yestickainumber@1@db.viqpwrttemnajhjvxsqp.supabase.co:5432/postgres';

async function run() {
  const client = new Client({ connectionString, ssl: { rejectUnauthorized: false } });
  await client.connect();
  
  try {
    await client.query(`
      ALTER TABLE public.customer_profiles 
      ADD COLUMN IF NOT EXISTS measurements JSONB,
      ADD COLUMN IF NOT EXISTS plan_name VARCHAR,
      ADD COLUMN IF NOT EXISTS plan_price DECIMAL,
      ADD COLUMN IF NOT EXISTS plan_details VARCHAR;
    `);
    console.log("Success adding columns");
  } catch (e) {
    console.error(e);
  } finally {
    await client.end();
  }
}
run();
