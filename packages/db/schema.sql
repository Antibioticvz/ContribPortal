-- ContribPortal Database Schema
-- PostgreSQL-compatible schema for Supabase

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "btree_gin";

-- Users table (extends Supabase auth.users)
-- This table stores additional user profile information
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  name TEXT,
  github_username TEXT UNIQUE,
  bio TEXT,
  experience_level TEXT CHECK (experience_level IN ('beginner', 'intermediate', 'advanced')) DEFAULT 'beginner',
  preferred_languages TEXT[], -- Programming languages user prefers
  location TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Technologies table (catalog of technologies/skills)
CREATE TABLE IF NOT EXISTS technologies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE, -- e.g., 'JavaScript', 'Python', 'React', 'Docker'
  category TEXT NOT NULL, -- e.g., 'language', 'framework', 'tool', 'database'
  description TEXT,
  icon_url TEXT, -- URL to technology icon/logo
  color TEXT, -- Hex color for UI display
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User technologies junction table (users' skills)
CREATE TABLE IF NOT EXISTS user_technologies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  technology_id UUID NOT NULL REFERENCES technologies(id) ON DELETE CASCADE,
  proficiency_level TEXT CHECK (proficiency_level IN ('learning', 'beginner', 'intermediate', 'advanced', 'expert')) DEFAULT 'beginner',
  years_experience INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, technology_id)
);

-- Projects table (open-source projects)
CREATE TABLE IF NOT EXISTS projects (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  github_id BIGINT UNIQUE NOT NULL, -- GitHub repository ID
  name TEXT NOT NULL,
  full_name TEXT NOT NULL, -- e.g., 'owner/repo'
  description TEXT,
  homepage_url TEXT,
  github_url TEXT NOT NULL,
  clone_url TEXT,
  language TEXT, -- Primary language
  license TEXT,
  stars_count INTEGER DEFAULT 0,
  forks_count INTEGER DEFAULT 0,
  open_issues_count INTEGER DEFAULT 0,
  size_kb INTEGER DEFAULT 0,
  is_fork BOOLEAN DEFAULT FALSE,
  is_archived BOOLEAN DEFAULT FALSE,
  is_disabled BOOLEAN DEFAULT FALSE,
  visibility TEXT CHECK (visibility IN ('public', 'private')) DEFAULT 'public',
  default_branch TEXT DEFAULT 'main',
  topics TEXT[], -- GitHub topics/tags
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_push_at TIMESTAMP WITH TIME ZONE,
  ai_analysis JSONB, -- Store AI-generated analysis about the project
  difficulty_score INTEGER CHECK (difficulty_score >= 1 AND difficulty_score <= 10), -- 1=beginner, 10=expert
  contributor_friendly_score INTEGER CHECK (contributor_friendly_score >= 1 AND contributor_friendly_score <= 10)
);

-- Project technologies junction table (project tech stacks)
CREATE TABLE IF NOT EXISTS project_technologies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  technology_id UUID NOT NULL REFERENCES technologies(id) ON DELETE CASCADE,
  is_primary BOOLEAN DEFAULT FALSE, -- Mark primary/main technologies
  usage_percentage FLOAT, -- Percentage of codebase using this technology
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(project_id, technology_id)
);

-- Tasks table (issues/tasks within projects)
CREATE TABLE IF NOT EXISTS tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  github_issue_id BIGINT UNIQUE NOT NULL, -- GitHub issue ID
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  github_url TEXT NOT NULL,
  issue_number INTEGER NOT NULL,
  state TEXT CHECK (state IN ('open', 'closed')) DEFAULT 'open',
  labels TEXT[], -- GitHub labels
  assignees TEXT[], -- GitHub usernames of assignees
  difficulty TEXT CHECK (difficulty IN ('good first issue', 'easy', 'medium', 'hard')) DEFAULT 'medium',
  estimated_hours INTEGER, -- Estimated time to complete
  priority TEXT CHECK (priority IN ('low', 'medium', 'high', 'urgent')) DEFAULT 'medium',
  type TEXT CHECK (type IN ('bug', 'feature', 'documentation', 'testing', 'refactoring', 'enhancement')) DEFAULT 'feature',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  closed_at TIMESTAMP WITH TIME ZONE,
  ai_analysis JSONB, -- Store AI-generated analysis about the task
  beginner_friendly BOOLEAN DEFAULT FALSE,
  help_wanted BOOLEAN DEFAULT FALSE,
  UNIQUE(project_id, issue_number)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_github_username ON users(github_username);
CREATE INDEX IF NOT EXISTS idx_users_experience_level ON users(experience_level);
CREATE INDEX IF NOT EXISTS idx_users_preferred_languages ON users USING GIN(preferred_languages);

CREATE INDEX IF NOT EXISTS idx_technologies_name ON technologies(name);
CREATE INDEX IF NOT EXISTS idx_technologies_category ON technologies(category);

CREATE INDEX IF NOT EXISTS idx_user_technologies_user_id ON user_technologies(user_id);
CREATE INDEX IF NOT EXISTS idx_user_technologies_technology_id ON user_technologies(technology_id);
CREATE INDEX IF NOT EXISTS idx_user_technologies_proficiency ON user_technologies(proficiency_level);

CREATE INDEX IF NOT EXISTS idx_projects_github_id ON projects(github_id);
CREATE INDEX IF NOT EXISTS idx_projects_name ON projects(name);
CREATE INDEX IF NOT EXISTS idx_projects_language ON projects(language);
CREATE INDEX IF NOT EXISTS idx_projects_stars_count ON projects(stars_count DESC);
CREATE INDEX IF NOT EXISTS idx_projects_topics ON projects USING GIN(topics);
CREATE INDEX IF NOT EXISTS idx_projects_difficulty ON projects(difficulty_score);
CREATE INDEX IF NOT EXISTS idx_projects_updated_at ON projects(updated_at DESC);

CREATE INDEX IF NOT EXISTS idx_project_technologies_project_id ON project_technologies(project_id);
CREATE INDEX IF NOT EXISTS idx_project_technologies_technology_id ON project_technologies(technology_id);
CREATE INDEX IF NOT EXISTS idx_project_technologies_primary ON project_technologies(is_primary) WHERE is_primary = TRUE;

CREATE INDEX IF NOT EXISTS idx_tasks_project_id ON tasks(project_id);
CREATE INDEX IF NOT EXISTS idx_tasks_github_issue_id ON tasks(github_issue_id);
CREATE INDEX IF NOT EXISTS idx_tasks_state ON tasks(state);
CREATE INDEX IF NOT EXISTS idx_tasks_difficulty ON tasks(difficulty);
CREATE INDEX IF NOT EXISTS idx_tasks_labels ON tasks USING GIN(labels);
CREATE INDEX IF NOT EXISTS idx_tasks_beginner_friendly ON tasks(beginner_friendly) WHERE beginner_friendly = TRUE;
CREATE INDEX IF NOT EXISTS idx_tasks_help_wanted ON tasks(help_wanted) WHERE help_wanted = TRUE;
CREATE INDEX IF NOT EXISTS idx_tasks_created_at ON tasks(created_at DESC);

-- Row Level Security (RLS) policies
-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE technologies ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_technologies ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_technologies ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Users can read their own profile and update it
CREATE POLICY "Users can read own profile" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE USING (auth.uid() = id);

-- Allow users to insert their own profile (after signup)
CREATE POLICY "Users can insert own profile" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Technologies are readable by everyone (public catalog)
CREATE POLICY "Technologies are readable by everyone" ON technologies
  FOR SELECT USING (true);

-- User technologies: users can manage their own skills
CREATE POLICY "Users can read own technologies" ON user_technologies
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own technologies" ON user_technologies
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own technologies" ON user_technologies
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own technologies" ON user_technologies
  FOR DELETE USING (auth.uid() = user_id);

-- Projects are readable by everyone (public data)
CREATE POLICY "Projects are readable by everyone" ON projects
  FOR SELECT USING (visibility = 'public');

-- Project technologies are readable by everyone
CREATE POLICY "Project technologies are readable by everyone" ON project_technologies
  FOR SELECT USING (true);

-- Tasks are readable by everyone for public projects
CREATE POLICY "Tasks are readable by everyone" ON tasks
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM projects 
      WHERE projects.id = tasks.project_id 
      AND projects.visibility = 'public'
    )
  );

-- Create a function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to automatically update the updated_at column
CREATE TRIGGER update_users_updated_at 
  BEFORE UPDATE ON users 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_projects_updated_at 
  BEFORE UPDATE ON projects 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at 
  BEFORE UPDATE ON tasks 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert some initial technology data
INSERT INTO technologies (name, category, description, color) VALUES
  ('JavaScript', 'language', 'Dynamic programming language for web development', '#F7DF1E'),
  ('TypeScript', 'language', 'Typed superset of JavaScript', '#3178C6'),
  ('Python', 'language', 'High-level programming language', '#3776AB'),
  ('Java', 'language', 'Object-oriented programming language', '#007396'),
  ('C++', 'language', 'Systems programming language', '#00599C'),
  ('Rust', 'language', 'Systems programming language focused on safety', '#000000'),
  ('Go', 'language', 'Programming language developed by Google', '#00ADD8'),
  ('React', 'framework', 'JavaScript library for building user interfaces', '#61DAFB'),
  ('Next.js', 'framework', 'React framework for production', '#000000'),
  ('Vue.js', 'framework', 'Progressive JavaScript framework', '#4FC08D'),
  ('Angular', 'framework', 'TypeScript-based web application framework', '#DD0031'),
  ('Node.js', 'runtime', 'JavaScript runtime built on Chrome V8 engine', '#339933'),
  ('Express.js', 'framework', 'Fast, unopinionated web framework for Node.js', '#000000'),
  ('NestJS', 'framework', 'Progressive Node.js framework', '#E0234E'),
  ('Django', 'framework', 'High-level Python web framework', '#092E20'),
  ('Flask', 'framework', 'Lightweight Python web framework', '#000000'),
  ('Spring Boot', 'framework', 'Java-based framework', '#6DB33F'),
  ('Docker', 'tool', 'Containerization platform', '#2496ED'),
  ('Kubernetes', 'tool', 'Container orchestration platform', '#326CE5'),
  ('PostgreSQL', 'database', 'Advanced open source relational database', '#336791'),
  ('MongoDB', 'database', 'Document-oriented NoSQL database', '#47A248'),
  ('Redis', 'database', 'In-memory data structure store', '#DC382D'),
  ('MySQL', 'database', 'Open source relational database', '#4479A1'),
  ('Git', 'tool', 'Distributed version control system', '#F05032'),
  ('GitHub Actions', 'tool', 'CI/CD platform by GitHub', '#2088FF'),
  ('AWS', 'cloud', 'Amazon Web Services cloud platform', '#FF9900'),
  ('Azure', 'cloud', 'Microsoft cloud computing platform', '#0078D4'),
  ('Google Cloud', 'cloud', 'Google Cloud Platform', '#4285F4')
ON CONFLICT (name) DO NOTHING;