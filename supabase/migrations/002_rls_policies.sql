-- ============================================================================
-- CYBERSPRINT 180 — ROW LEVEL SECURITY (RLS) POLICIES
-- Strict user boundary isolation + public read for curriculum and educational content
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.months ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.weeks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_checklist_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_daily_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.checklist_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.xp_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.project_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_project_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookmarks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.test_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.test_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interview_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_interview_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.career_profiles ENABLE ROW LEVEL SECURITY;

-- ----------------------------------------------------------------------------
-- PUBLIC READABLE EDUCATIONAL CONTENT
-- Anyone authenticated or unauthenticated can read curriculum & public materials
-- ----------------------------------------------------------------------------

CREATE POLICY "Allow public read for months" ON public.months FOR SELECT USING (true);
CREATE POLICY "Allow public read for weeks" ON public.weeks FOR SELECT USING (true);
CREATE POLICY "Allow public read for daily_tasks" ON public.daily_tasks FOR SELECT USING (true);
CREATE POLICY "Allow public read for daily_checklist_items" ON public.daily_checklist_items FOR SELECT USING (true);
CREATE POLICY "Allow public read for resources" ON public.resources FOR SELECT USING (true);
CREATE POLICY "Allow public read for daily_resources" ON public.daily_resources FOR SELECT USING (true);
CREATE POLICY "Allow public read for projects" ON public.projects FOR SELECT USING (true);
CREATE POLICY "Allow public read for project_tasks" ON public.project_tasks FOR SELECT USING (true);
CREATE POLICY "Allow public read for skills" ON public.skills FOR SELECT USING (true);
CREATE POLICY "Allow public read for achievements" ON public.achievements FOR SELECT USING (true);
CREATE POLICY "Allow public read for tests" ON public.tests FOR SELECT USING (true);
CREATE POLICY "Allow public read for questions" ON public.questions FOR SELECT USING (true);
CREATE POLICY "Allow public read for interview_questions" ON public.interview_questions FOR SELECT USING (true);

-- ----------------------------------------------------------------------------
-- USER BOUNDARY POLICIES (Users manage only their own data)
-- ----------------------------------------------------------------------------

-- Profiles
CREATE POLICY "Users can read all profiles" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can update their own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert their own profile" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Settings
CREATE POLICY "Users can read own settings" ON public.user_settings FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own settings" ON public.user_settings FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own settings" ON public.user_settings FOR INSERT WITH CHECK (auth.uid() = user_id);

-- User Daily Progress
CREATE POLICY "Users can read own daily progress" ON public.user_daily_progress FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own daily progress" ON public.user_daily_progress FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own daily progress" ON public.user_daily_progress FOR UPDATE USING (auth.uid() = user_id);

-- Checklist Progress
CREATE POLICY "Users can read own checklist progress" ON public.checklist_progress FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own checklist progress" ON public.checklist_progress FOR ALL USING (auth.uid() = user_id);

-- Streaks
CREATE POLICY "Users can read own streak" ON public.streaks FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert/update own streak" ON public.streaks FOR ALL USING (auth.uid() = user_id);

-- XP Transactions
CREATE POLICY "Users can read own xp transactions" ON public.xp_transactions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own xp transactions" ON public.xp_transactions FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Study Sessions
CREATE POLICY "Users can manage own study sessions" ON public.study_sessions FOR ALL USING (auth.uid() = user_id);

-- Project Progress
CREATE POLICY "Users can manage own project progress" ON public.user_project_progress FOR ALL USING (auth.uid() = user_id);

-- Skills Progress
CREATE POLICY "Users can manage own skills" ON public.user_skills FOR ALL USING (auth.uid() = user_id);

-- User Achievements
CREATE POLICY "Users can read own achievements" ON public.user_achievements FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own achievements" ON public.user_achievements FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Notes
CREATE POLICY "Users can manage own notes" ON public.notes FOR ALL USING (auth.uid() = user_id);

-- Bookmarks
CREATE POLICY "Users can manage own bookmarks" ON public.bookmarks FOR ALL USING (auth.uid() = user_id);

-- Test Attempts & Answers
CREATE POLICY "Users can read own test attempts" ON public.test_attempts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own test attempts" ON public.test_attempts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can manage own test answers" ON public.test_answers FOR ALL USING (
    EXISTS (SELECT 1 FROM public.test_attempts WHERE id = attempt_id AND user_id = auth.uid())
);

-- Interview Progress
CREATE POLICY "Users can manage own interview progress" ON public.user_interview_progress FOR ALL USING (auth.uid() = user_id);

-- Career Profiles
CREATE POLICY "Users can read all career profiles" ON public.career_profiles FOR SELECT USING (true);
CREATE POLICY "Users can manage own career profile" ON public.career_profiles FOR ALL USING (auth.uid() = user_id);
