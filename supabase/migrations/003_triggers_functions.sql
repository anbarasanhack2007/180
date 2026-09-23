-- ============================================================================
-- CYBERSPRINT 180 — DATABASE FUNCTIONS & TRIGGERS
-- Automated profile creation, streak tracking, and XP computation
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Automatic User Profile Creation on Signup
-- ----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name, role)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
        'student'
    )
    ON CONFLICT (id) DO NOTHING;

    -- Also create initial settings and streak
    INSERT INTO public.user_settings (user_id)
    VALUES (NEW.id)
    ON CONFLICT (user_id) DO NOTHING;

    INSERT INTO public.streaks (user_id, current_streak, longest_streak)
    VALUES (NEW.id, 0, 0)
    ON CONFLICT (user_id) DO NOTHING;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger firing after new user is inserted in auth.users
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ----------------------------------------------------------------------------
-- 2. Daily Streak Update Function
-- ----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.update_user_streak(p_user_id UUID)
RETURNS VOID AS $$
DECLARE
    v_last_activity DATE;
    v_current_streak INT;
    v_longest_streak INT;
    v_today DATE := CURRENT_DATE;
BEGIN
    SELECT last_activity_date, current_streak, longest_streak
    INTO v_last_activity, v_current_streak, v_longest_streak
    FROM public.streaks
    WHERE user_id = p_user_id;

    IF NOT FOUND THEN
        INSERT INTO public.streaks (user_id, current_streak, longest_streak, last_activity_date)
        VALUES (p_user_id, 1, 1, v_today);
        RETURN;
    END IF;

    IF v_last_activity = v_today THEN
        -- Already active today, streak unchanged
        RETURN;
    ELSIF v_last_activity = v_today - 1 THEN
        -- Consecutive day! Increment streak
        v_current_streak := v_current_streak + 1;
        IF v_current_streak > v_longest_streak THEN
            v_longest_streak := v_current_streak;
        END IF;
    ELSE
        -- Streak broken
        v_current_streak := 1;
    END IF;

    UPDATE public.streaks
    SET current_streak = v_current_streak,
        longest_streak = v_longest_streak,
        last_activity_date = v_today,
        updated_at = timezone('utc'::text, now())
    WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger updating streak when day task or checklist item completed
CREATE OR REPLACE FUNCTION public.trigger_activity_streak()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.completed = true THEN
        PERFORM public.update_user_streak(NEW.user_id);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_daily_task_completed ON public.user_daily_progress;
CREATE TRIGGER on_daily_task_completed
    AFTER INSERT OR UPDATE ON public.user_daily_progress
    FOR EACH ROW EXECUTE FUNCTION public.trigger_activity_streak();
