const { Client } = require('pg');

const connectionString = 'postgresql://postgres:Yestickainumber@1@db.viqpwrttemnajhjvxsqp.supabase.co:5432/postgres';

const client = new Client({
  connectionString: connectionString,
});

async function run() {
  try {
    await client.connect();
    console.log('Connected to Supabase PostgreSQL!');

    // Create Advanced Schema: RLS, Triggers
    const query = `
      -- 1. Enable RLS on all tables
      ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
      ALTER TABLE public.shirts ENABLE ROW LEVEL SECURITY;
      ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;

      -- 2. Drop existing policies to prevent errors on re-run
      DROP POLICY IF EXISTS "Public shirts are viewable by everyone." ON public.shirts;
      DROP POLICY IF EXISTS "Users can view their own profile." ON public.profiles;
      DROP POLICY IF EXISTS "Users can update their own profile." ON public.profiles;
      DROP POLICY IF EXISTS "Customers can view their own orders." ON public.orders;
      DROP POLICY IF EXISTS "Customers can insert their own orders." ON public.orders;
      DROP POLICY IF EXISTS "Drivers can view assigned orders." ON public.orders;
      DROP POLICY IF EXISTS "Drivers can update assigned orders." ON public.orders;

      -- 3. Profiles Policies
      CREATE POLICY "Users can view their own profile." 
        ON public.profiles FOR SELECT 
        USING ( auth.uid() = id );
        
      CREATE POLICY "Users can update their own profile." 
        ON public.profiles FOR UPDATE 
        USING ( auth.uid() = id );

      -- 4. Shirts Policies (Read-Only for public, Admin management handled by service role key)
      CREATE POLICY "Public shirts are viewable by everyone." 
        ON public.shirts FOR SELECT 
        USING ( true );

      -- 5. Orders Policies
      CREATE POLICY "Customers can view their own orders." 
        ON public.orders FOR SELECT 
        USING ( auth.uid() = customer_id );
        
      CREATE POLICY "Customers can insert their own orders." 
        ON public.orders FOR INSERT 
        WITH CHECK ( auth.uid() = customer_id );

      CREATE POLICY "Drivers can view assigned orders." 
        ON public.orders FOR SELECT 
        USING ( auth.uid() = driver_id OR status = 'pending' );

      CREATE POLICY "Drivers can update assigned orders." 
        ON public.orders FOR UPDATE 
        USING ( auth.uid() = driver_id );

      -- 6. Trigger for New User Signups
      -- This automatically creates a profile when a user signs up via Supabase Auth
      CREATE OR REPLACE FUNCTION public.handle_new_user() 
      RETURNS trigger AS $$
      BEGIN
        INSERT INTO public.profiles (id, full_name, role)
        VALUES (new.id, COALESCE(new.raw_user_meta_data->>'full_name', 'User'), COALESCE(new.raw_user_meta_data->>'role', 'customer'));
        RETURN new;
      END;
      $$ LANGUAGE plpgsql SECURITY DEFINER;

      DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
      CREATE TRIGGER on_auth_user_created
        AFTER INSERT ON auth.users
        FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

    `;

    await client.query(query);
    console.log('Backend Features (RLS & Triggers) successfully configured!');
  } catch (error) {
    console.error('Error executing query:', error);
  } finally {
    await client.end();
  }
}

run();
