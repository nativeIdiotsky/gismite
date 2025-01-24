
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://veyppvuphkshygoedifz.supabase.co'; // gismite Supabase URL
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZleXBwdnVwaGtzaHlnb2VkaWZ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjUxOTI5MDcsImV4cCI6MjA0MDc2ODkwN30._RQivrIPethD7fSWowr5ESl08khEKGcAd1jQJWp2ToE'; // gismite Supabase Anon Key

export const supabase = createClient(supabaseUrl, supabaseKey);
