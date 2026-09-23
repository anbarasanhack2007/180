-- ============================================================================
-- CYBERSPRINT 180 — DATABASE SCHEMA
-- PostgreSQL / Supabase Schema for Full-Stack Cybersecurity Learning Platform
-- ============================================================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ----------------------------------------------------------------------------
-- 1. PROFILES & USER SETTINGS
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    college TEXT,
    degree TEXT,
    study_year INT DEFAULT 2,
    daily_goal_minutes INT DEFAULT 120,
    avatar_url TEXT,
    github_url TEXT,
    linkedin_url TEXT,
    portfolio_url TEXT,
    role TEXT NOT NULL DEFAULT 'student' CHECK (role IN ('student', 'admin', 'instructor')),
    cybersecurity_level TEXT DEFAULT 'SOC Analyst & Incident Responder',
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.user_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE UNIQUE,
    daily_reminder_enabled BOOLEAN DEFAULT true,
    reminder_time TEXT DEFAULT '08:00',
    sound_effects_enabled BOOLEAN DEFAULT true,
    theme_mode TEXT DEFAULT 'dark' CHECK (theme_mode IN ('dark', 'light', 'cyber')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- ----------------------------------------------------------------------------
-- 2. 180-DAY CURRICULUM ARCHITECTURE
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.months (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    month_number INT NOT NULL UNIQUE CHECK (month_number BETWEEN 1 AND 6),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    objectives JSONB NOT NULL DEFAULT '[]'::jsonb,
    days_start INT NOT NULL,
    days_end INT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.weeks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    month_id UUID NOT NULL REFERENCES public.months(id) ON DELETE CASCADE,
    week_number INT NOT NULL UNIQUE CHECK (week_number BETWEEN 1 AND 24),
    title TEXT NOT NULL,
    objective TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.daily_tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    week_id UUID NOT NULL REFERENCES public.weeks(id) ON DELETE CASCADE,
    day_number INT NOT NULL UNIQUE CHECK (day_number BETWEEN 1 AND 180),
    title TEXT NOT NULL,
    objective TEXT NOT NULL,
    description TEXT NOT NULL,
    estimated_minutes INT NOT NULL DEFAULT 120,
    lab_instructions TEXT,
    xp_reward INT NOT NULL DEFAULT 50,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.daily_checklist_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    day_task_id UUID NOT NULL REFERENCES public.daily_tasks(id) ON DELETE CASCADE,
    item_order INT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.resources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    category TEXT NOT NULL,
    type TEXT NOT NULL, -- video, lab, doc, book, tool
    platform TEXT,     -- YouTube, TryHackMe, PortSwigger, OWASP
    url TEXT NOT NULL,
    description TEXT,
    icon TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.daily_resources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    day_task_id UUID NOT NULL REFERENCES public.daily_tasks(id) ON DELETE CASCADE,
    resource_id UUID NOT NULL REFERENCES public.resources(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    UNIQUE(day_task_id, resource_id)
);

-- ----------------------------------------------------------------------------
-- 3. PROGRESS, STREAKS & GAMIFICATION
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.user_daily_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    day_task_id UUID NOT NULL REFERENCES public.daily_tasks(id) ON DELETE CASCADE,
    completed BOOLEAN NOT NULL DEFAULT false,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    UNIQUE(user_id, day_task_id)
);

CREATE TABLE IF NOT EXISTS public.checklist_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    checklist_item_id UUID NOT NULL REFERENCES public.daily_checklist_items(id) ON DELETE CASCADE,
    completed BOOLEAN NOT NULL DEFAULT false,
    completed_at TIMESTAMPTZ,
    UNIQUE(user_id, checklist_item_id)
);

CREATE TABLE IF NOT EXISTS public.streaks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE UNIQUE,
    current_streak INT NOT NULL DEFAULT 0,
    longest_streak INT NOT NULL DEFAULT 0,
    last_activity_date DATE,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.xp_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    amount INT NOT NULL,
    reason TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.study_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    day_task_id UUID REFERENCES public.daily_tasks(id) ON DELETE SET NULL,
    duration_minutes INT NOT NULL,
    started_at TIMESTAMPTZ NOT NULL,
    ended_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- ----------------------------------------------------------------------------
-- 4. CAPSTONE PROJECTS & MILESTONES
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    slug TEXT NOT NULL UNIQUE,
    month_id UUID REFERENCES public.months(id) ON DELETE SET NULL,
    description TEXT NOT NULL,
    objectives JSONB NOT NULL DEFAULT '[]'::jsonb,
    architecture_summary TEXT,
    tech_stack JSONB NOT NULL DEFAULT '[]'::jsonb,
    github_template_url TEXT,
    xp_reward INT NOT NULL DEFAULT 500,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.project_tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
    task_order INT NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.user_project_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    project_id UUID NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'not_started' CHECK (status IN ('not_started', 'in_progress', 'completed')),
    github_repo_url TEXT,
    completed_at TIMESTAMPTZ,
    UNIQUE(user_id, project_id)
);

-- ----------------------------------------------------------------------------
-- 5. SKILLS MATRIX & ACHIEVEMENTS
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.skills (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category TEXT NOT NULL, -- Networking, Linux, Web Security, Defense/SOC, Offensive
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    icon TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.user_skills (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    skill_id UUID NOT NULL REFERENCES public.skills(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'learning' CHECK (status IN ('not_started', 'learning', 'practicing', 'mastered')),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    UNIQUE(user_id, skill_id)
);

CREATE TABLE IF NOT EXISTS public.achievements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL UNIQUE,
    description TEXT NOT NULL,
    badge_icon TEXT NOT NULL,
    xp_reward INT NOT NULL DEFAULT 100,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.user_achievements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    achievement_id UUID NOT NULL REFERENCES public.achievements(id) ON DELETE CASCADE,
    unlocked_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    UNIQUE(user_id, achievement_id)
);

-- ----------------------------------------------------------------------------
-- 6. FIELD NOTES & BOOKMARKS
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    day_task_id UUID REFERENCES public.daily_tasks(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    tags JSONB DEFAULT '[]'::jsonb,
    is_pinned BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.bookmarks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    item_type TEXT NOT NULL CHECK (item_type IN ('mission', 'resource', 'lab', 'note')),
    day_number INT,
    url TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- ----------------------------------------------------------------------------
-- 7. TESTS & ASSESSMENTS ENGINE
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.tests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    week_id UUID REFERENCES public.weeks(id) ON DELETE SET NULL,
    month_id UUID REFERENCES public.months(id) ON DELETE SET NULL,
    title TEXT NOT NULL,
    description TEXT,
    test_type TEXT NOT NULL CHECK (test_type IN ('weekly', 'monthly', 'final')),
    duration_minutes INT NOT NULL DEFAULT 30,
    passing_score INT NOT NULL DEFAULT 75,
    xp_reward INT NOT NULL DEFAULT 100,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    test_id UUID NOT NULL REFERENCES public.tests(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    options JSONB NOT NULL, -- Array of string options
    correct_option_index INT NOT NULL,
    explanation TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.test_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    test_id UUID NOT NULL REFERENCES public.tests(id) ON DELETE CASCADE,
    score INT NOT NULL,
    total_points INT NOT NULL,
    passed BOOLEAN NOT NULL,
    completed_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.test_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    attempt_id UUID NOT NULL REFERENCES public.test_attempts(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
    selected_option_index INT NOT NULL,
    is_correct BOOLEAN NOT NULL
);

-- ----------------------------------------------------------------------------
-- 8. INTERVIEW QUESTIONS & CAREER PROFILES
-- ----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS public.interview_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category TEXT NOT NULL,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    difficulty TEXT NOT NULL DEFAULT 'Medium' CHECK (difficulty IN ('Easy', 'Medium', 'Hard')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.user_interview_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES public.interview_questions(id) ON DELETE CASCADE,
    status TEXT NOT NULL DEFAULT 'review' CHECK (status IN ('review', 'mastered')),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    UNIQUE(user_id, question_id)
);

CREATE TABLE IF NOT EXISTS public.career_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE UNIQUE,
    headline TEXT,
    bio TEXT,
    skills_json JSONB DEFAULT '[]'::jsonb,
    projects_json JSONB DEFAULT '[]'::jsonb,
    certifications_json JSONB DEFAULT '[]'::jsonb,
    education_json JSONB DEFAULT '[]'::jsonb,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);
