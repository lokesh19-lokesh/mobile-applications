const { Client } = require('pg');
const connectionString = 'postgresql://postgres:Yestickainumber@1@db.viqpwrttemnajhjvxsqp.supabase.co:5432/postgres';

async function check() {
  const client = new Client({ connectionString, ssl: { rejectUnauthorized: false } });
  await client.connect();
  const res1 = await client.query('SELECT * FROM auth.users');
  const res2 = await client.query('SELECT * FROM public.users');
  const res3 = await client.query('SELECT * FROM public.customer_profiles');
  console.log('auth.users:', res1.rows);
  console.log('public.users:', res2.rows);
  console.log('customer_profiles:', res3.rows);
  await client.end();
}
check();
