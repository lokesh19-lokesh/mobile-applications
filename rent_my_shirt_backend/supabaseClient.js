require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.SUPABASE_URL || 'https://viqpwrttemnajhjvxsqp.supabase.co';
const supabaseKey = process.env.SUPABASE_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZpcXB3cnR0ZW1uYWpoanZ4c3FwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODEwODc1NTIsImV4cCI6MjA5NjY2MzU1Mn0.nACZXJlEWoX0CoLlEr6XwmXY9ol9qwK9Q9-hKdgSVDs';

const supabase = createClient(supabaseUrl, supabaseKey);

module.exports = { supabase };
