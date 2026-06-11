const { Client } = require('pg');

const connectionString = 'postgresql://postgres:Yestickainumber@1@db.viqpwrttemnajhjvxsqp.supabase.co:5432/postgres';

const client = new Client({
  connectionString: connectionString,
});

async function run() {
  try {
    await client.connect();
    
    const query = `
      CREATE OR REPLACE FUNCTION public.handle_new_user() 
      RETURNS trigger AS $$
      BEGIN
        -- Insert into the correct new tables
        INSERT INTO public.users (id, email, role)
        VALUES (new.id, new.email, 'CUSTOMER'::user_role);
        
        INSERT INTO public.customer_profiles (user_id, first_name)
        VALUES (new.id, COALESCE(new.raw_user_meta_data->>'full_name', 'User'));
        
        RETURN new;
      END;
      $$ LANGUAGE plpgsql SECURITY DEFINER;

      -- Ensure the trigger is active
      DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
      CREATE TRIGGER on_auth_user_created
        AFTER INSERT ON auth.users
        FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
    `;

    await client.query(query);
    console.log('Trigger fixed successfully to use public.users and public.customer_profiles');
  } catch (error) {
    console.error('Error executing query:', error);
  } finally {
    await client.end();
  }
}

run();
