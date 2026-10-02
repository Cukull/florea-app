# Floréa — Database Schema (Supabase / PostgreSQL)

> Pasangan dari `DATABASE_ERD.md`. Jalankan sebagai migrasi Supabase.
> Prasyarat: extension `pgcrypto` untuk `gen_random_uuid()`.

## 0. Setup

```sql
create extension if not exists "pgcrypto";

-- Enums
create type task_priority as enum ('low','medium','high','urgent');
create type task_status as enum ('pending','in_progress','completed','cancelled');
create type habit_frequency as enum ('daily','weekly','custom');
create type focus_mode as enum ('pomodoro','deep_focus','exam_mode');
create type focus_status as enum ('active','paused','completed','cancelled');
create type notification_type as enum ('task','deadline','sleep','habit','wellness','hydration','eye_rest','focus_break');

-- Trigger updated_at
create or replace function set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;
```

## 1. profiles

```sql
create table profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  full_name text,
  avatar_url text,
  onboarding_completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
drop trigger if exists trg_profiles_updated on profiles;
create trigger trg_profiles_updated before update on profiles
  for each row execute function set_updated_at();

alter table profiles enable row level security;
create policy "profiles_owner" on profiles
  for all using (auth.uid() = id) with check (auth.uid() = id);
```

## 2. user_goals

```sql
create table user_goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text,
  target_date date,
  is_completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_user_goals_user on user_goals(user_id);
alter table user_goals enable row level security;
create policy "user_goals_owner" on user_goals
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
```

## 3. task_categories

```sql
create table task_categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  color text,
  icon text,
  created_at timestamptz not null default now()
);
create index idx_task_categories_user on task_categories(user_id);
alter table task_categories enable row level security;
create policy "task_categories_owner" on task_categories
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
```

## 4. tasks

```sql
create table tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  category_id uuid references task_categories(id) on delete set null,
  title text not null,
  description text,
  deadline timestamptz,
  priority task_priority not null default 'medium',
  status task_status not null default 'pending',
  progress int not null default 0 check (progress between 0 and 100),
  reminder_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_tasks_user_deadline on tasks(user_id, deadline);
create index idx_tasks_user_status on tasks(user_id, status);
alter table tasks enable row level security;
create policy "tasks_owner" on tasks
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
```

## 5. habits + habit_logs

```sql
create table habits (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text,
  frequency habit_frequency not null default 'daily',
  target_per_week int check (target_per_week between 1 and 7),
  color text,
  icon text,
  reminder_time time,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index idx_habits_user on habits(user_id);

create table habit_logs (
  id uuid primary key default gen_random_uuid(),
  habit_id uuid not null references habits(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  logged_date date not null,
  is_completed boolean not null default true,
  note text,
  created_at timestamptz not null default now(),
  unique(habit_id, logged_date)
);
create index idx_habit_logs_habit_date on habit_logs(habit_id, logged_date);

alter table habits enable row level security;
create policy "habits_owner" on habits
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
alter table habit_logs enable row level security;
create policy "habit_logs_owner" on habit_logs
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
```

## 6. mood_logs

```sql
create table mood_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  mood_score int not null check (mood_score between 1 and 5),
  mood_label text,
  note text,
  logged_at timestamptz not null default now()
);
create index idx_mood_logs_user_time on mood_logs(user_id, logged_at desc);
alter table mood_logs enable row level security;
create policy "mood_logs_owner" on mood_logs
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
```

## 7. sleep_logs

```sql
create table sleep_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  sleep_date date not null,
  bedtime timestamptz,
  wake_time timestamptz,
  quality int check (quality between 1 and 5),
  note text,
  created_at timestamptz not null default now(),
  unique(user_id, sleep_date)
);
create index idx_sleep_logs_user_date on sleep_logs(user_id, sleep_date desc);
alter table sleep_logs enable row level security;
create policy "sleep_logs_owner" on sleep_logs
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
```

## 8. focus_sessions

```sql
create table focus_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  mode focus_mode not null default 'pomodoro',
  planned_minutes int not null check (planned_minutes > 0),
  actual_minutes int,
  started_at timestamptz not null default now(),
  ended_at timestamptz,
  status focus_status not null default 'active',
  note text
);
create index idx_focus_user_time on focus_sessions(user_id, started_at desc);
alter table focus_sessions enable row level security;
create policy "focus_owner" on focus_sessions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
```

## 9. notifications

```sql
create table notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  type notification_type not null,
  title text not null,
  body text,
  scheduled_for timestamptz,
  is_read boolean not null default false,
  related_id uuid,
  created_at timestamptz not null default now()
);
create index idx_notifications_user_sched on notifications(user_id, scheduled_for);
alter table notifications enable row level security;
create policy "notifications_owner" on notifications
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
```

## 10. achievements

```sql
create table achievements (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  title text not null,
  description text,
  icon text,
  criteria jsonb not null default '{}'
);

create table user_achievements (
  user_id uuid not null references auth.users(id) on delete cascade,
  achievement_id uuid not null references achievements(id) on delete cascade,
  progress int not null default 0,
  unlocked_at timestamptz,
  primary key (user_id, achievement_id)
);

alter table user_achievements enable row level security;
create policy "user_achievements_owner" on user_achievements
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
-- achievements: read untuk semua user login
alter table achievements enable row level security;
create policy "achievements_read" on achievements for select using (true);
```

## 11. Seed awal (contoh)

```sql
insert into achievements (code, title, description) values
  ('first_task','Langkah Pertama','Selesaikan 1 task pertama'),
  ('focus_3','Fokus 3x','Selesaikan 3 focus session'),
  ('mood_7','Refleksi 7 Hari','Catat mood 7 hari berturut-turut')
on conflict (code) do nothing;
```

## 12. Checklist Migrasi

- [ ] Jalankan di Supabase SQL Editor / `supabase/migrations/`
- [ ] Test RLS: user A tidak bisa baca data user B
- [ ] Test Flutter: CRUD 1 task + 1 mood + 1 focus session
