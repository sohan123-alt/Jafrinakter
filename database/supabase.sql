-- Education Table
CREATE TABLE IF NOT EXISTS education (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    degree TEXT NOT NULL,
    department TEXT NOT NULL,
    institution TEXT NOT NULL,
    session TEXT NOT NULL,
    result TEXT,
    duration TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'Completed', -- Completed/Ongoing
    display_order INTEGER DEFAULT 0,
    visible BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Research Papers Table
CREATE TABLE IF NOT EXISTS research_papers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    authors TEXT NOT NULL,
    journal TEXT NOT NULL,
    year INTEGER NOT NULL,
    doi TEXT,
    abstract TEXT,
    keywords TEXT,
    category TEXT,
    status TEXT DEFAULT 'Published',
    pdf_url TEXT,
    external_url TEXT,
    thumbnail TEXT,
    featured BOOLEAN DEFAULT false,
    visible BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security
ALTER TABLE education ENABLE ROW LEVEL SECURITY;
ALTER TABLE research_papers ENABLE ROW LEVEL SECURITY;

-- RLS Policies for Education
CREATE POLICY "Public can view visible education" ON education
    FOR SELECT USING (visible = true);

CREATE POLICY "Admin can do everything on education" ON education
    FOR ALL USING (auth.role() = 'authenticated');

-- RLS Policies for Research Papers
CREATE POLICY "Public can view visible research papers" ON research_papers
    FOR SELECT USING (visible = true);

CREATE POLICY "Admin can do everything on research papers" ON research_papers
    FOR ALL USING (auth.role() = 'authenticated');

-- Indexes
CREATE INDEX IF NOT EXISTS idx_education_display_order ON education(display_order);
CREATE INDEX IF NOT EXISTS idx_research_papers_year ON research_papers(year DESC);
CREATE INDEX IF NOT EXISTS idx_research_papers_featured ON research_papers(featured);

-- Function to handle updated_at
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers
CREATE TRIGGER set_updated_at_education
    BEFORE UPDATE ON education
    FOR EACH ROW
    EXECUTE FUNCTION handle_updated_at();

CREATE TRIGGER set_updated_at_research_papers
    BEFORE UPDATE ON research_papers
    FOR EACH ROW
    EXECUTE FUNCTION handle_updated_at();
