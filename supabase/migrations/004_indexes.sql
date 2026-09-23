-- ============================================================================
-- CYBERSPRINT 180 — PERFORMANCE INDEXES
-- Indexing high-traffic columns for sub-millisecond query execution
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_weeks_month_id ON public.weeks(month_id);
CREATE INDEX IF NOT EXISTS idx_daily_tasks_week_id ON public.daily_tasks(week_id);
CREATE INDEX IF NOT EXISTS idx_daily_tasks_day_number ON public.daily_tasks(day_number);
CREATE INDEX IF NOT EXISTS idx_checklist_day_task_id ON public.daily_checklist_items(day_task_id);
CREATE INDEX IF NOT EXISTS idx_user_daily_progress_user ON public.user_daily_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_daily_progress_task ON public.user_daily_progress(day_task_id);
CREATE INDEX IF NOT EXISTS idx_checklist_progress_user ON public.checklist_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_xp_transactions_user ON public.xp_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_study_sessions_user ON public.study_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_notes_user_id ON public.notes(user_id);
CREATE INDEX IF NOT EXISTS idx_bookmarks_user_id ON public.bookmarks(user_id);
CREATE INDEX IF NOT EXISTS idx_questions_test_id ON public.questions(test_id);
CREATE INDEX IF NOT EXISTS idx_test_attempts_user_id ON public.test_attempts(user_id);
CREATE INDEX IF NOT EXISTS idx_interview_category ON public.interview_questions(category);
CREATE INDEX IF NOT EXISTS idx_skills_category ON public.skills(category);
