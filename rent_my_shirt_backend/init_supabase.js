const { Client } = require('pg');

const connectionString = 'postgresql://postgres:Yestickainumber@1@db.viqpwrttemnajhjvxsqp.supabase.co:5432/postgres';

const client = new Client({
  connectionString: connectionString,
});

async function run() {
  try {
    await client.connect();
    console.log('Connected to Supabase PostgreSQL!');

    // Create Tables
    await client.query(`
      CREATE TABLE IF NOT EXISTS public.profiles (
        id UUID REFERENCES auth.users(id) PRIMARY KEY,
        full_name TEXT NOT NULL,
        phone TEXT UNIQUE,
        role TEXT DEFAULT 'customer' CHECK (role IN ('customer', 'driver', 'admin')),
        wallet_balance NUMERIC DEFAULT 0,
        security_deposit_paid BOOLEAN DEFAULT false,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );
      
      CREATE TABLE IF NOT EXISTS public.shirts (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        title TEXT NOT NULL,
        brand TEXT NOT NULL,
        price_per_day NUMERIC NOT NULL,
        image_url TEXT,
        sizes TEXT[],
        category TEXT,
        is_available BOOLEAN DEFAULT true,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );

      CREATE TABLE IF NOT EXISTS public.orders (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        customer_id UUID REFERENCES public.profiles(id),
        driver_id UUID REFERENCES public.profiles(id),
        shirt_id UUID REFERENCES public.shirts(id),
        status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'assigned', 'picked_up', 'delivered', 'returned', 'completed')),
        rental_days INT NOT NULL,
        total_price NUMERIC NOT NULL,
        pickup_address TEXT NOT NULL,
        delivery_address TEXT,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );
      
      -- Insert some mock shirts
      INSERT INTO public.shirts (title, brand, price_per_day, image_url, sizes, category, is_available)
      VALUES 
      ('Premium Velvet Tuxedo', 'Velvet & Thread', 499.00, 'assets/images/tuxedo_banner.png', ARRAY['M', 'L', 'XL'], 'Tuxedos', true),
      ('Summer Floral Print', 'Shirtly', 199.00, 'assets/images/summer_banner.png', ARRAY['S', 'M', 'L'], 'Casual', true)
      ON CONFLICT DO NOTHING;
    `);

    console.log('Tables created successfully!');
  } catch (error) {
    console.error('Error executing query:', error);
  } finally {
    await client.end();
  }
}

run();
