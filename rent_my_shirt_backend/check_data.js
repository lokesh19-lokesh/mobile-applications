const { supabase } = require('./supabaseClient');

async function check() {
  const { data: users, error: uErr } = await supabase.from('users').select('*');
  const { data: profiles, error: pErr } = await supabase.from('customer_profiles').select('*');
  console.log('Users:', users);
  console.log('Profiles:', profiles);
}
check();
