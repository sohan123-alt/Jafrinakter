// ========================================
// SUPABASE CONFIG
// ========================================

const SUPABASE_URL = 'https://rwknomjpkumeipttubrm.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_HK8W0cFXwmkKpHoapBhGRw_J7upgT1Y';

// Create Supabase Client
const supabaseClient = window.supabase.createClient(
    SUPABASE_URL,
    SUPABASE_ANON_KEY
);

// Make Global
window.supabaseClient = supabaseClient;
