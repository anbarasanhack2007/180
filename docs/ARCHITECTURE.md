# 🏛️ CyberSprint 180 — Technical Architecture

CyberSprint 180 is built following **Clean Architecture** patterns, **Riverpod State Management**, and **GoRouter Navigation**.

---

## 1. Directory Structure

```
lib/
├── app/
│   ├── app.dart              # Main application widget with Cyber theme
│   ├── router.dart           # GoRouter declarations with auth & onboarding guards
│   └── theme/
│       ├── app_colors.dart   # Cyberpunk / terminal neon color palette
│       ├── app_text_styles.dart # Space Grotesk Google Fonts typography
│       └── app_theme.dart    # ThemeData configurations
├── core/
│   ├── constants/            # App routes, storage keys, Supabase config
│   └── widgets/              # CyberBackground, CyberButton, CyberTextField, MainShell
├── data/
│   ├── models/               # JSON-serializable DTOs (curriculum, profiles, progress)
│   └── repositories/         # Concrete repository implementations (Auth, Curriculum, Progress)
├── domain/
│   └── entities/             # Pure Dart domain entities (DailyTask, Month, Week, Streak)
├── features/                 # Modular feature domains
│   ├── achievements/         # Badges and unlock progression
│   ├── admin/                # Faculty dashboard, cadet roster, curriculum manager, exam vault
│   ├── analytics/            # FL Chart telemetry, study hours, domain mastery radar
│   ├── auth/                 # Login, Signup, Forgot Password, Onboarding
│   ├── bookmarks/            # Vault for saved missions, labs, and resources
│   ├── daily_mission/        # 180-day mission engine, Pomodoro timer, checklist
│   ├── dashboard/            # Command home, XP level, flame streak, today's mission
│   ├── interview/            # Technical scrimmage, 150+ flashcards, answer keys
│   ├── labs/                 # TryHackMe & PortSwigger interactive labs tracker
│   ├── notes/                # Markdown field notes, tags, pin to top
│   ├── portfolio/            # Student dossier, resume builder, capstone projects
│   ├── projects/             # 6 Capstone projects with milestone tasks
│   ├── resources/            # Curated arsenal of YouTube, TryHackMe, and docs
│   ├── resume/               # ATS-friendly PDF resume generator
│   ├── roadmap/              # 180-day visual interactive roadmap
│   ├── search/               # Global search across curriculum, projects, and interview questions
│   ├── settings/             # System configuration, schedule reminders, cloud sync
│   ├── skills/               # Skill tree across 5 core cybersecurity domains
│   └── tests/                # Quizzes, proctored monthly exams, scoring engine
└── services/
    └── supabase_service.dart # Supabase client singleton & table accessors
```

---

## 2. Authentication & Route Guarding

- **GoRouter** continuously listens to `authStateProvider`.
- Unauthenticated users attempting to access protected routes are immediately rerouted to `/login`.
- Cadets signing in for the first time without an active profile are rerouted to `/onboarding` to declare their daily study target and career specializations.

---

## 3. Offline-First Resilience

Every repository (`CurriculumRepository`, `ProgressRepository`, `AuthRepository`) contains complete offline fallbacks. If the user is learning in an offline environment (such as on a train, plane, or without internet), the complete 180-day curriculum, projects, interview questions, and exams load seamlessly.
