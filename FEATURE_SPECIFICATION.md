# Floréa — Feature Specification (POV User)

> Sumber: breakdown board POV User (8 kolom, owner UI: Kanaya Tabitha Putri)
> Stack: Flutter + Dart + go_router + Riverpod + Supabase
> Palet warna = contoh sementara, jangan dikunci (lihat TECH_STACK §4)

## Konvensi Dokumen

Setiap fitur wajib mendefinisikan (sesuai guardrails agent):

```text
Route → Page/Widget → Provider → Repository/Tabel → Validasi → Loading/Error/Empty → Test
```

Status prioritas MVP semester:

- **P0** = wajib ada saat demo/penilaian
- **P1** = ada bila P0 selesai
- **P2** = nice-to-have, tunda bila waktu mepet

---

## F1 — Login / Register & Onboarding (P0)

Board: Email/Username, Password, Login, Register, Forgot Password, Google Login,
Account Verification, User Goal, Wellness Goal, Initial Mood.

| Item | Keputusan |
|---|---|
| Route | `/login`, `/register`, `/forgot-password`, `/verify`, `/onboarding` |
| Page | `features/auth/{login,register,forgot_password,verify,onboarding}_page.dart` |
| Provider | `auth_provider` (session), `onboarding_provider` (goal + initial mood sementara) |
| Tabel | `auth.users` via Supabase Auth, `profiles` (onboarding_completed, full_name, avatar), `user_goals`, `mood_logs` (initial mood = 1 entry) |
| Validasi | Email valid, password ≥ 8 char, forgot-password kirim link Supabase |
| States | Loading saat Auth, error中华 (email sudah terdaftar / kredensial salah), empty tidak ada |
| Test | Unit validator + widget login form |

Catatan: **Google Login = P1** (butuh SHA-1 + OAuth client, aktifkan setelah flow email stabil).
Account Verification ikut alur Supabase (email link/OTP).

## F2 — Create Account (P0, bagian dari F1)

Board: Name, Email, Password, Confirm Password, Verification Code, User Goal/Interest.

| Item | Keputusan |
|---|---|
| Route | `/register` (+ `/verify`) |
| Page | `register_page.dart` (form) + `verify_page.dart` |
| Provider | `auth_provider` |
| Tabel | `profiles` (name), `user_goals` (goal/interest, ≥1 goal boleh kosong dulu) |
| Validasi | Name wajib, confirm password harus sama, kode verifikasi 6 digit |
| Test | Widget register (mismatch password ditolak) |

## F3 — Home Dashboard (P0)

Board: Today's Overview, Task/Schedule, Upcoming Events, Mood Check, Habit Journey,
Progress Overview, Notifications, Quick Action.

| Item | Keputusan |
|---|---|
| Route | `/home` |
| Page | `features/home/home_page.dart` + widget `today_overview_card, quick_action_bar, mood_check_sheet` |
| Provider | `home_provider` (agregasi), reuse `task_provider`, `habit_provider`, `mood_provider` |
| Tabel (read-only) | `tasks` (deadline hari ini + upcoming), `habit_logs` (today), `mood_logs` (today), `notifications` (unread count) |
| Aksi | Quick Action → `/planner/create`, mood check → bottom sheet → insert `mood_logs`, tap notif → daftar notif |
| States | Skeleton saat agregasi, empty ("Belum ada task hari ini"), error retry |
| Test | Widget home dengan 0 task vs N task |

## F4 — Planner Dashboard (P0, inti)

Board: Calendar, Weekly Schedule, Task List, Add/Edit Task, Deadline, Priority,
Task Status, Task Progress, Reminder.
Status: **Upcoming / In Progress / Completed**.

| Item | Keputusan |
|---|---|
| Route | `/planner`, `/planner/create`, `/planner/:id`, `/planner/:id/edit` |
| Page | `planner_page.dart` (tab: Calendar \| Weekly \| List) + `create_task_page`, `task_detail_page`, `edit_task_page` |
| Provider | `task_provider` (filter status + tanggal), `category_provider` |
| Tabel | `task_categories`, `tasks` (`deadline, priority[low|medium|high|urgent], status[pending|in_progress|completed|cancelled], progress 0–100, reminder_at`) |
| Mapping status board | Upcoming = `pending` + deadline > now · In Progress = `in_progress` · Completed = `completed` |
| Validasi | Title wajib, deadline ≥ now bila reminder dipakai, progress 0–100 |
| Reminder | Insert `notifications` (type task/deadline) + `flutter_local_notifications` schedule via `notification_service` |
| States | Loading list, error retry, empty per filter ("Tidak ada task In Progress") |
| Test | Unit filter status + progress calc, widget create-task form |

## F5 — Focus Dashboard (P0 inti, P1 pelengkap)

Board: Focus Timer, Pomodoro, Deep Focus, Exam Mode, Focus Session/History,
Focus Shield, Soundscape, Eye Rest, Mini Walk, Quick Stretch, Hydration Reminder.

| Item | Keputusan |
|---|---|
| Route | `/focus`, `/focus/pomodoro`, `/focus/deep`, `/focus/exam`, `/focus/history` |
| Page | `focus_page.dart` + mode pages + `focus_history_page.dart` |
| Provider | `focus_provider` (timer state machine: idle → running → paused → finished; wajib survive background via timestamp, bukan counter) |
| Tabel | `focus_sessions` (`mode[pomodoro|deep_focus|exam_mode], planned_minutes, actual_minutes, started_at, ended_at, status`) |
| Mode | Pomodoro P0 (25/5), Deep Focus P0 (durasi bebas), Exam Mode P1 (Focus Shield = DND/blocking notif selama sesi) |
| Pelengkap | Soundscape P2 (asset audio lokal), Eye Rest / Mini Walk / Quick Stretch P1 (timer pendek + panduan teks, tanpa tabel baru), Hydration Reminder P1 (notif berulang) |
| Test | Unit timer calc (actual_minutes dari selisih timestamp), widget start→finish 1 sesi |

## F6 — Wellness Dashboard (P0 inti, P1 analitik)

Board: Mood Tracking, Mood Analytics, Habit Tracking, Habit Journey, Sleep Tracking,
Wellness Progress, Daily Wellness, Wellness Reminder.

| Item | Keputusan |
|---|---|
| Route | `/wellness`, `/wellness/mood`, `/wellness/habits`, `/wellness/sleep` |
| Page | `wellness_page.dart` (tab Mood \| Habit \| Sleep) + sub-pages |
| Provider | `mood_provider`, `habit_provider`, `sleep_provider` |
| Tabel | `mood_logs` (score 1–5 + note), `habits` + `habit_logs` (unik per hari), `sleep_logs` (bedtime/wake/quality 1–5) |
| Analitik | Mood Analytics + Wellness Progress = P1 via `fl_chart` (agregasi 7/30 hari). Daily Wellness = ringkasan read-only. Reminder via `notification_service` |
| Validasi | Mood 1–5 wajib, sleep wake > bedtime, habit 1 log/hari |
| Test | Unit streak habit + rata-rata mood mingguan |

## F7 — Profile Dashboard (P0 dasar, P1 statistik)

Board: Task/Focus Statistics, Habit Progress, Mood History, Wellness Progress,
Achievement, Personalized Insight, Profile, Personal Information, Notifications,
Privacy & Security, Account Settings, Logout (tertulis 2x di board = 1 aksi).

| Item | Keputusan |
|---|---|
| Route | `/profile`, `/profile/edit`, `/profile/settings`, `/profile/achievements` |
| Page | `profile_page.dart` + `edit_profile_page`, `settings_page`, `achievements_page` |
| Provider | `user_provider`, `settings_provider` (theme, pref notif di `shared_preferences`) |
| Tabel | `profiles`, `user_achievements` + `achievements` (read), statistik = agregasi `tasks/focus_sessions/habit_logs/mood_logs` (tanpa tabel baru) |
| Personalized Insight | P2 (rule sederhana dulu, mis. "3 hari fokus terbaikmu…"; tanpa LLM) |
| Settings | Edit nama/avatar (Storage bila perlu) P0, Notifications toggle P0, Privacy & Security (ganti password via Supabase) P1, Logout P0 |
| Test | Widget profile edit + logout clears session |

---

## Peta Route Final (go_router)

```text
/login /register /forgot-password /verify /onboarding
/home
/planner /planner/create /planner/:id /planner/:id/edit
/focus /focus/pomodoro /focus/deep /focus/exam /focus/history
/wellness /wellness/mood /wellness/habits /wellness/sleep
/profile /profile/edit /profile/settings /profile/achievements
```

## Peta Tabel Final

```text
profiles, user_goals
task_categories, tasks
habits, habit_logs
mood_logs, sleep_logs
focus_sessions
notifications
achievements, user_achievements
```

Tidak ada tabel baru di luar ERD/SCHEMA. Insight & Daily Wellness = query agregasi.

## Urutan Build (disarankan)

```text
1. F1+F2 Auth + profiles          (blokir semua fitur lain)
2. F4 Planner CRUD + reminder      (nilai inti produktivitas)
3. F5 Focus timer + history        (nilai inti fokus)
4. F6 Mood/Habit/Sleep entry       (nilai inti wellness)
5. F3 Home agregasi                (butuh 2–4 selesai dulu)
6. F6 analitik + F7 statistik      (chart + achievements)
7. F7 settings + insight sederhana
8. P1/P2: Google login, Exam mode shield, soundscape, FCM
```
