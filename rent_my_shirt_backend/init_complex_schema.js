const { Client } = require('pg');

const connectionString = 'postgresql://postgres:Yestickainumber@1@db.viqpwrttemnajhjvxsqp.supabase.co:5432/postgres';

const client = new Client({
  connectionString: connectionString,
});

async function run() {
  try {
    await client.connect();
    console.log('Connected to Supabase PostgreSQL!');

    const query = `
      -- 0. Drop existing schema (Cascading to remove dependencies)
      DROP TABLE IF EXISTS public.orders CASCADE;
      DROP TABLE IF EXISTS public.deposits CASCADE;
      DROP TABLE IF EXISTS public.addresses CASCADE;
      DROP TABLE IF EXISTS public.shirt_inventory CASCADE;
      DROP TABLE IF EXISTS public.shirts CASCADE;
      DROP TABLE IF EXISTS public.shirt_categories CASCADE;
      DROP TABLE IF EXISTS public.delivery_agents CASCADE;
      DROP TABLE IF EXISTS public.customer_profiles CASCADE;
      DROP TABLE IF EXISTS public.users CASCADE;
      
      -- Drop old simplified table if it exists
      DROP TABLE IF EXISTS public.profiles CASCADE;

      -- 1. Create ENUMs
      DO $$ BEGIN
          CREATE TYPE user_role AS ENUM ('CUSTOMER', 'DRIVER', 'ADMIN');
      EXCEPTION WHEN duplicate_object THEN null; END $$;

      DO $$ BEGIN
          CREATE TYPE kyc_status AS ENUM ('PENDING', 'VERIFIED', 'REJECTED');
      EXCEPTION WHEN duplicate_object THEN null; END $$;

      DO $$ BEGIN
          CREATE TYPE size_enum AS ENUM ('S', 'M', 'L', 'XL', 'XXL');
      EXCEPTION WHEN duplicate_object THEN null; END $$;

      DO $$ BEGIN
          CREATE TYPE shirt_status AS ENUM ('AVAILABLE', 'RENTED', 'LAUNDRY', 'MAINTENANCE', 'DAMAGED', 'LOST');
      EXCEPTION WHEN duplicate_object THEN null; END $$;

      DO $$ BEGIN
          CREATE TYPE deposit_status AS ENUM ('HELD', 'REFUNDED', 'FORFEITED');
      EXCEPTION WHEN duplicate_object THEN null; END $$;

      DO $$ BEGIN
          CREATE TYPE order_status AS ENUM ('PENDING', 'CONFIRMED', 'OUT_FOR_DELIVERY', 'DELIVERED', 'RETURN_REQUESTED', 'RETURN_PICKED', 'COMPLETED', 'CANCELLED');
      EXCEPTION WHEN duplicate_object THEN null; END $$;

      -- 2. Create Tables
      CREATE TABLE public.users (
        id UUID REFERENCES auth.users(id) PRIMARY KEY,
        phone VARCHAR UNIQUE,
        email VARCHAR UNIQUE,
        role user_role DEFAULT 'CUSTOMER',
        is_active BOOLEAN DEFAULT true,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );

      CREATE TABLE public.customer_profiles (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
        first_name VARCHAR,
        last_name VARCHAR,
        kyc_status kyc_status DEFAULT 'PENDING',
        rating DECIMAL DEFAULT 5.0
      );

      CREATE TABLE public.delivery_agents (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
        vehicle_number VARCHAR,
        driving_license VARCHAR,
        is_online BOOLEAN DEFAULT false,
        current_lat DECIMAL,
        current_lng DECIMAL
      );

      CREATE TABLE public.shirt_categories (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        name VARCHAR NOT NULL
      );

      CREATE TABLE public.shirts (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        category_id UUID REFERENCES public.shirt_categories(id),
        name VARCHAR NOT NULL,
        brand VARCHAR NOT NULL,
        description TEXT,
        price_1_day DECIMAL NOT NULL,
        price_1_week DECIMAL NOT NULL,
        price_1_month DECIMAL NOT NULL
      );

      CREATE TABLE public.shirt_inventory (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        shirt_id UUID REFERENCES public.shirts(id) ON DELETE CASCADE,
        size size_enum NOT NULL,
        color VARCHAR,
        qr_code VARCHAR UNIQUE,
        status shirt_status DEFAULT 'AVAILABLE',
        condition_rating INT DEFAULT 5
      );

      CREATE TABLE public.addresses (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
        address_line TEXT NOT NULL
      );

      CREATE TABLE public.deposits (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
        amount DECIMAL DEFAULT 5000,
        payment_id VARCHAR,
        status deposit_status DEFAULT 'HELD'
      );

      CREATE TABLE public.orders (
        id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
        user_id UUID REFERENCES public.users(id),
        status order_status DEFAULT 'PENDING',
        total_amount DECIMAL NOT NULL,
        delivery_agent_id UUID REFERENCES public.delivery_agents(id),
        pickup_address_id UUID REFERENCES public.addresses(id),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );

      -- 3. Update Auth Trigger
      CREATE OR REPLACE FUNCTION public.handle_new_user() 
      RETURNS trigger AS $$
      BEGIN
        INSERT INTO public.users (id, email, role)
        VALUES (new.id, new.email, 'CUSTOMER'::user_role);
        
        INSERT INTO public.customer_profiles (user_id, first_name)
        VALUES (new.id, COALESCE(new.raw_user_meta_data->>'full_name', 'User'));
        
        RETURN new;
      END;
      $$ LANGUAGE plpgsql SECURITY DEFINER;

      -- 4. Mock Data Setup (to keep the apps working during prototyping)
      INSERT INTO public.shirt_categories (id, name) VALUES ('11111111-1111-1111-1111-111111111111', 'Tuxedos') ON CONFLICT DO NOTHING;
      INSERT INTO public.shirt_categories (id, name) VALUES ('22222222-2222-2222-2222-222222222222', 'Casual') ON CONFLICT DO NOTHING;

      INSERT INTO public.shirts (id, category_id, name, brand, description, price_1_day, price_1_week, price_1_month) 
      VALUES 
      ('33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', 'Premium Velvet Tuxedo', 'Velvet & Thread', 'Elegant tuxedo', 499.00, 2500.00, 8000.00),
      ('44444444-4444-4444-4444-444444444444', '22222222-2222-2222-2222-222222222222', 'Summer Floral Print', 'Shirtly', 'Vibrant summer wear', 199.00, 1000.00, 3000.00)
      ON CONFLICT DO NOTHING;

      INSERT INTO public.shirt_inventory (shirt_id, size, color, qr_code, status)
      VALUES 
      ('33333333-3333-3333-3333-333333333333', 'M', 'Black', 'QR-TUX-M-01', 'AVAILABLE'),
      ('33333333-3333-3333-3333-333333333333', 'L', 'Black', 'QR-TUX-L-01', 'AVAILABLE'),
      ('44444444-4444-4444-4444-444444444444', 'S', 'Floral', 'QR-SUM-S-01', 'AVAILABLE')
      ON CONFLICT DO NOTHING;
    `;

    await client.query(query);
    console.log('Complex schema successfully created!');
  } catch (error) {
    console.error('Error executing query:', error);
  } finally {
    await client.end();
  }
}

run();
