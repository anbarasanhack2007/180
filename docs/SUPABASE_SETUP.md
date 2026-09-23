# 🛡️ Supabase Setup & Backend Configuration Guide

This guide walks you through provisioning your PostgreSQL database, applying the migrations, and seeding the 180-day curriculum for **CyberSprint 180**.

---

## 1. Create a Supabase Project

1. Navigate to [Supabase](https://supabase.com) and sign in.
2. Click **New Project**.
3. Choose a project name (e.g. `cybersprint-180`), set a secure database password, and choose your nearest region.
4. Wait ~2 minutes for the database cluster to finish provisioning.

---

## 2. Obtain Your API Credentials

1. In your project dashboard, navigate to **Project Settings** > **API**.
2. Copy the **Project URL** (e.g., `https://xyzabcdefg.supabase.co`).
3. Copy the **anon (public)** key.

Create a `.env` file in the root of the project:

```bash
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-public-key-here
```

---

## 3. Apply SQL Migrations

Open the **SQL Editor** in your Supabase dashboard and run the migration scripts in sequential order:

1. **`supabase/migrations/001_initial_schema.sql`**
   - Creates all 35 relational tables with UUIDs, foreign keys, and constraints.
2. **`supabase/migrations/002_rls_policies.sql`**
   - Enables Row Level Security (RLS) across all tables with granular student and faculty isolation.
3. **`supabase/migrations/003_triggers_functions.sql`**
   - Configures the automatic signup trigger (`on_auth_user_created`) and streak tracker.
4. **`supabase/migrations/004_indexes.sql`**
   - Creates B-Tree performance indexes on high-frequency query paths.

---

## 4. Seed the Curriculum Data

In the **SQL Editor**, paste and execute:

- **`supabase/seed.sql`**
  - Seeds all 6 Months, 24 Weeks, 180 Daily Missions with objectives and checklist tasks.
  - Seeds 6 real-world capstone projects with technical architectures.
  - Seeds badges, achievements, and 150+ interview questions.

---

## 5. Running the Flutter App

You can run the app with credentials passed via `--dart-define` or using your `.env` file:

```bash
# Debug mode with environment definitions
flutter run --dart-define=SUPABASE_URL=https://xyz.supabase.co \
            --dart-define=SUPABASE_ANON_KEY=eyJhbGci...

# Or on Chrome
flutter run -d chrome --dart-define=SUPABASE_URL=https://xyz.supabase.co \
                      --dart-define=SUPABASE_ANON_KEY=eyJhbGci...
```
