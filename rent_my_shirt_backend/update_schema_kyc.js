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

    // Add KYC columns to customer_profiles
    const alterQuery = `
      ALTER TABLE public.customer_profiles 
      ADD COLUMN IF NOT EXISTS phone_number VARCHAR,
      ADD COLUMN IF NOT EXISTS company_name VARCHAR,
      ADD COLUMN IF NOT EXISTS company_id_card_url VARCHAR;
    `;
    
    await client.query(alterQuery);
    console.log('Successfully added KYC columns to customer_profiles.');
    
    // Create the kyc_documents storage bucket if it doesn't exist
    // Supabase storage buckets are tracked in storage.buckets table
    const createBucketQuery = `
      INSERT INTO storage.buckets (id, name, public) 
      VALUES ('kyc_documents', 'kyc_documents', true)
      ON CONFLICT (id) DO NOTHING;
    `;
    await client.query(createBucketQuery);
    console.log('Successfully ensured kyc_documents storage bucket exists.');

    // Add Storage Policies to allow public read and authenticated inserts
    const policyQuery = `
      DO $$ BEGIN
        CREATE POLICY "Give public access to kyc_documents" ON storage.objects FOR SELECT USING (bucket_id = 'kyc_documents');
      EXCEPTION WHEN duplicate_object THEN null; END $$;
      
      DO $$ BEGIN
        CREATE POLICY "Allow authenticated uploads to kyc_documents" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'kyc_documents');
      EXCEPTION WHEN duplicate_object THEN null; END $$;
      
      DO $$ BEGIN
        CREATE POLICY "Allow anon uploads to kyc_documents" ON storage.objects FOR INSERT TO anon WITH CHECK (bucket_id = 'kyc_documents');
      EXCEPTION WHEN duplicate_object THEN null; END $$;
    `;
    await client.query(policyQuery);
    console.log('Successfully added storage policies for kyc_documents.');

  } catch (err) {
    console.error('Error updating schema:', err);
  } finally {
    await client.end();
  }
}

updateSchema();
