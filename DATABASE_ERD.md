# Floréa — Database ERD

> Status: Proposal — validasi sebelum migrasi Supabase
> DB: PostgreSQL (Supabase) | Auth: Supabase Auth (`auth.users`)

## 1. Aturan Global

1. Semua tabel user-data punya `user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE`.
2. Semua tabel pakai `id UUID PRIMARY KEY DEFAULT gen_random_uuid()`.
3. Waktu simpan UTC (`timestamptz`), tampilkan waktu lokal via `intl`.
4. RLS aktif di semua tabel user-data. Policy inti: user hanya CRUD miliknya sendiri.
5. `created_at timestamptz DEFAULT now()`, `updated_at` diupdate via trigger (lihat SCHEMA).

## 2. ERD (Mermaid)

```mermaid
erDiagram
    AUTH_USERS ||--o| PROFILES : has
    PROFILES ||--o{ USER_GOALS : owns
    PROFILES ||--o{ TASK_CATEGORIES : owns
    PROFILES ||--o{ TASKS : owns
    TASK_CATEGORIES ||--o{ TASKS : groups
    PROFILES ||--o{ HABITS : owns
    HABITS ||--o{ HABIT_LOGS : logs
    PROFILES ||--o{ MOOD_LOGS : owns
    PROFILES ||--o{ SLEEP_LOGS : owns
    PROFILES ||--o{ FOCUS_SESSIONS : owns
    PROFILES ||--o{ NOTIFICATIONS : owns
    PROFILES ||--o{ USER_ACHIEVEMENTS : unlocks
    ACHIEVEMENTS ||--o{ USER_ACHIEVEMENTS : grants

    AUTH_USERS {
        uuid id PK
    }
    PROFILES {
        uuid id PK_FK
        text email
        text full_name
        text avatar_url
        bool onboarding_completed
    }
    USER_GOALS {
        uuid id PK
        uuid user_id FK
        text title
        date target_date
        bool is_completed
    }
    TASK_CATEGORIES {
        uuid id PK
        uuid user_id FK
        text name
        text color
    }
    TASKS {
        uuid id PK
        uuid user_id FK
        uuid category_id FK
        text title
        timestamptz deadline
        text priority
        text status
        int progress
    }
    HABITS {
        uuid id PK
        uuid user_id FK
        text title
        text frequency
        time reminder_time
        bool is_active
    }
    HABIT_LOGS {
        uuid id PK
        uuid habit_id FK
        uuid user_id FK
        date logged_date
        bool is_completed
    }
    MOOD_LOGS {
        uuid id PK
        uuid user_id FK
        int mood_score
        timestamptz logged_at
    }
    SLEEP_LOGS {
        uuid id PK
        uuid user_id FK
        date sleep_date
        timestamptz bedtime
        timestamptz wake_time
        int quality
    }
    FOCUS_SESSIONS {
        uuid id PK
        uuid user_id FK
        text mode
        int planned_minutes
        int actual_minutes
        text status
    }
    NOTIFICATIONS {
        uuid id PK
        uuid user_id FK
        text type
        text title
        timestamptz scheduled_for
        bool is_read
    }
    ACHIEVEMENTS {
        uuid id PK
        text code
        text title
    }
    USER_ACHIEVEMENTS {
        uuid user_id FK
        uuid achievement_id FK
        timestamptz unlocked_at
    }
```

## 3. Relasi per Fitur

- **Planner:** profiles → task_categories → tasks. Task tanpa kategori diizinkan (`category_id NULL`).
- **Habit:** habits → habit_logs. Unik per `(habit_id, logged_date)` agar tidak dobel log harian.
- **Mood / Sleep / Focus:** langsung ke profiles (tidak ada tabel anak). Query statistik via agregasi tanggal.
- **Notification:** milik user, `related_id` opsional menunjuk task/habit (tanpa FK keras agar fleksibel).
- **Achievement:** master `achievements` (seed) + `user_achievements` (composite PK).

## 4. Enums (Postgres)

```text
task_priority: low | medium | high | urgent
task_status: pending | in_progress | completed | cancelled
habit_frequency: daily | weekly | custom
focus_mode: pomodoro | deep_focus | exam_mode
focus_status: active | paused | completed | cancelled
notification_type: task | deadline | sleep | habit | wellness | hydration | eye_rest | focus_break
```

Dibuat via `CREATE TYPE ... AS ENUM`. Detail kolom lihat `DATABASE_SCHEMA.md`.

## 5. Indeks Wajib

```text
tasks(user_id, deadline)
tasks(user_id, status)
habit_logs(habit_id, logged_date)
mood_logs(user_id, logged_at DESC)
sleep_logs(user_id, sleep_date DESC)
focus_sessions(user_id, started_at DESC)
notifications(user_id, scheduled_for)
```

## 6. Validasi Sebelum Migrasi

- [ ] ERD disetujui tim
- [ ] Enum final (tidak tambah-ubah seenaknya setelah seed)
- [ ] RLS policy per tabel dicek (lihat SCHEMA)
- [ ] Seed `achievements` awal disepakati
