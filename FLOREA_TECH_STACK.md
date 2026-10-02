# Floréa — Technical Stack (Flutter)

> **Status:** Proposal for confirmation before implementation
>
> **Project:** Floréa — *Balance Your Mind, Study & Life*
>
> **Academic Context:** Semester 7 — Teknik Informatika
>
> **Development Approach:** AI-assisted development / Vibe Coding using OpenCode
>
> **Base:** Dart + Flutter (revisi dari React Native + Expo per permintaan tim)

---

## 1. Document Purpose

Dokumen ini mendefinisikan teknologi utama yang digunakan untuk membangun aplikasi mobile **Floréa** dengan **Flutter**.

Dokumen ini dibuat sebagai **baseline teknis untuk dikonfirmasi di OpenCode sebelum coding dimulai**. Setelah dikonfirmasi, perubahan besar terhadap stack sebaiknya dilakukan hanya jika ada kebutuhan teknis yang jelas.

---

## 2. Project Context

Berdasarkan project board dan mockup Floréa, aplikasi ditujukan untuk membantu mahasiswa menjaga keseimbangan antara produktivitas akademik dan kesejahteraan pribadi.

Fitur utama yang teridentifikasi dari dokumen desain:

- Login / Register / Onboarding
- Create Account
- Home Dashboard
- Planner Dashboard
- Focus Dashboard
- Wellness Dashboard
- Profile Dashboard
- Calendar
- Weekly Schedule
- Task List
- Add / Edit Task
- Deadline
- Priority
- Task Status
- Task Progress
- Focus Timer
- Pomodoro
- Deep Focus
- Exam Mode
- Focus Session / History
- Focus Shield
- Soundscape
- Eye Rest
- Mini Walk
- Quick Stretch
- Hydration Reminder
- Mood Tracking
- Mood Analytics
- Habit Tracking
- Habit Journey / Progress
- Sleep Tracking
- Wellness Progress
- Daily Wellness
- Wellness Reminder
- Task Statistics
- Focus Statistics
- Mood History
- Achievement
- Personalized Insight
- Notifications
- Privacy & Security
- Account Settings

### Design system yang sudah terdokumentasi

- Display / Heading font: **Fraunces**
- Body / UI font: **DM Sans**
- Warm White: `#FAF7F2`
- Soft Purple: `#8B7CF8`
- Light Blue: `#EAF7FC`

---

# 3. Recommended Core Stack

## 3.1 Mobile Application

| Layer | Technology | Status | Purpose |
|---|---|---:|---|
| Mobile framework | **Flutter** | ✅ Proposed | Cross-platform mobile application (Android + iOS) |
| Programming language | **Dart** | ✅ Proposed | Application source code, null-safety |
| Navigation | **go_router** | ✅ Proposed | Declarative routing, deep-link, auth redirect |

### Decision

Use:

```text
Flutter + Dart + go_router
```

Alasan pilih go_router: router resmi Flutter, mendukung nested navigation (tabs), auth redirect (login → home), dan deep-link notifikasi. Alternatif `auto_route` ditolak agar tidak menambah codegen yang berat untuk MVP.

---

# 4. UI / UX Implementation

| Technology | Status | Purpose |
|---|---:|---|
| **Material 3 + Theme** | ✅ Proposed | Design token, color scheme, typography terpusat |
| **google_fonts** | ✅ Proposed | Fraunces + DM Sans tanpa bundel font manual |
| **flutter_svg** | ✅ Proposed | Ikon/ilustrasi SVG dari Figma |
| **lucide_icons** | ✅ Proposed | Consistent icon system (pengganti Lucide React Native) |
| **flutter_animate** | ✅ Proposed | Animasi UI ringan dan transisi (pengganti Reanimated) |
| **SafeArea (built-in)** | ✅ Proposed | Safe-area handling, tanpa package tambahan |

Gesture tidak butuh package khusus: gunakan `GestureDetector` / `Dismissible` bawaan Flutter.

### Typography

```text
Heading / Display
Fraunces

Body / UI
DM Sans
```

Implementasi via `google_fonts`:

```dart
TextTheme(
  displayLarge: GoogleFonts.fraunces(...),
  bodyMedium: GoogleFonts.dmSans(...),
)
```

### Initial Design Tokens (CONTOH SEMENTARA — JANGAN DIKUNCI)

> **Catatan tim:** palet di bawah hanya contoh dari PDF desain saat ini.
> Akan diganti saat dev setelah Figma final. Jangan hardcode hex di widget —
> selalu lewat `AppColors` / `ColorScheme` agar gampang diganti.

```dart
// PLACEHOLDER — akan diganti saat dev
class AppColors {
  static const warmWhite = Color(0xFFFAF7F2);
  static const softPurple = Color(0xFF8B7CF8);
  static const lightBlue = Color(0xFFEAF7FC);
}
```

Semantic tokens yang wajib dibuat di `core/theme/`:

```text
primary
secondary
background
surface
text
textSecondary
border
success
warning
danger
```

Nilai di atas hanya contoh sementara dari dokumen desain Floréa (tidak dikunci, akan diganti saat dev); token semantik tambahan adalah level implementasi dan tetap butuh konfirmasi UI.

---

# 5. State Management

## 5.1 Client / Global State

**flutter_riverpod**

Recommended providers:

```text
providers/
├── auth_provider.dart
├── user_provider.dart
├── task_provider.dart
├── focus_provider.dart
├── wellness_provider.dart
└── settings_provider.dart
```

### Responsibilities

- Authentication/session UI state
- User preferences
- Active task state
- Focus timer state
- Wellness interaction state
- App settings

Alasan pilih Riverpod (bukan Bloc/GetX/Provider): API paling sederhana untuk MVP, compile-safe, mudah di-test, dan mudah dibaca AI agent. Bloc terlalu boilerplate untuk deadline semester. GetX ditolak karena menggabungkan routing + DI + state secara implisit sehingga sulit di-review.

## 5.2 Server State / Data Fetching

**Riverpod + Dio** (atau langsung `supabase_flutter` untuk query Supabase)

Gunakan untuk:

- Fetching backend data
- Caching (via `FutureProvider` / `AsyncNotifier`)
- Refetching / invalidation
- Loading / error states
- Mutations
- Query invalidation

Pemisahan yang dianjurkan:

```text
Riverpod AsyncNotifier / FutureProvider
→ remote / server state (Supabase)

Riverpod Notifier / StateProvider
→ local UI / client state
```

Aturan: jangan panggil Supabase langsung dari widget. Lewat `repositories/` + `providers/`.

---

# 6. Backend

## Recommended backend platform: Supabase

| Supabase capability | Usage in Floréa |
|---|---|
| **Supabase Auth** | Login, register, session, password recovery |
| **PostgreSQL** | Primary application database |
| **Row Level Security (RLS)** | Per-user data access control |
| **Supabase Storage** | User-uploaded assets, if needed |
| **Edge Functions** | Server-side business logic when needed |
| **Realtime** | Optional; use only if a feature requires realtime updates |

Package: `supabase_flutter`.

### Architecture

```text
Flutter App
      ↓
Supabase Flutter Client
      ↓
Supabase
   ├── Auth
   ├── PostgreSQL
   ├── Storage
   └── Edge Functions (when needed)
```

---

# 7. Database

## Database engine

**PostgreSQL (via Supabase)**

### Initial entity candidates

Entitas berikut adalah proposal berdasarkan feature set. **Bukan schema final** dan harus divalidasi saat desain ERD/schema.

```text
profiles
user_goals
tasks
task_categories
habits
habit_logs
mood_logs
sleep_logs
focus_sessions
notifications
achievements
user_achievements
```

### General relationship model

```text
profiles
   │
   ├── user_goals
   ├── tasks
   ├── habits
   │     └── habit_logs
   ├── mood_logs
   ├── sleep_logs
   ├── focus_sessions
   ├── notifications
   └── user_achievements
               │
               └── achievements
```

**Important:** Final tables, fields, indexes, constraints, enums, and relationships must be defined in a separate Database/ERD specification before implementation.

---

# 8. Authentication

## Supabase Auth (via supabase_flutter)

Initial supported flow:

```text
Login
Register
Forgot Password
Email Verification
Session Management
Logout
```

Project board juga menunjukkan Google Login, sehingga:

```text
Google OAuth (google_sign_in + Supabase) → Proposed, ditunda
```

Google OAuth diaktifkan hanya setelah flow auth dan konfigurasi Supabase dikonfirmasi (butuh SHA-1 Android + OAuth client ID).

---

# 9. Forms & Validation

| Technology | Status | Purpose |
|---|---:|---|
| **Form (built-in) + TextEditingController** | ✅ Proposed | Form state and submission handling |
| **form_builder_validators** | ✅ Proposed | Schema-based validation (pengganti Zod) |

Expected usage:

```text
Login
Register
Create Task
Edit Task
Create Habit
Mood Entry
Sleep Entry
Profile / Settings
```

Aturan: 1 file validator terpusat di `core/validators/`, jangan tulis regex validasi di tiap screen.

---

# 10. Notifications & Reminders

## flutter_local_notifications

Package pendukung: `timezone`, `permission_handler`.

Potential use cases dari project board:

```text
Task Reminder
Deadline Reminder
Sleep Reminder
Habit Reminder
Wellness Reminder
Hydration Reminder
Eye Rest Reminder
Focus Break Reminder
```

Notification scheduling logic harus di service/module khusus, bukan di dalam widget.

Recommended location:

```text
lib/services/notification_service.dart
```

Push dari server (FCM) bersifat opsional dan hanya ditambahkan bila reminder lokal tidak cukup.

---

# 11. Local Storage

| Technology | Status | Purpose |
|---|---:|---|
| **shared_preferences** | ✅ Proposed | Non-sensitive local preferences and lightweight persistence |
| **flutter_secure_storage** | ✅ Proposed | Sensitive local values that require secure storage |

Contoh data shared_preferences:

```text
onboarding_completed
app_preferences
theme
notification_preferences
```

Timer persistence harus didesain hati-hati agar focus session dapat pulih setelah app lifecycle berubah (background / killed).

---

# 12. Charts & Analytics

## Proposed library

**fl_chart**

Potential visualizations:

```text
Mood Analytics
Focus Statistics
Task Statistics
Habit Progress
Wellness Progress
```

Tipe chart mengikuti Figma, jangan membuat pola visual baru yang tidak perlu.

---

# 13. Date & Time

## Proposed

**intl** (official) + `timezone` untuk scheduling

Use for:

- Task deadlines
- Calendar calculations
- Weekly schedule
- Habit log dates
- Focus session timestamps
- Sleep dates
- Reminder scheduling helpers

Timezone handling harus konsisten antara mobile dan backend (simpan UTC di Postgres, tampilkan waktu lokal).

---

# 14. Testing

## 14.1 Unit & Widget Testing

**flutter_test** (built-in)

Gunakan untuk business logic seperti:

- Timer calculations
- Progress calculations
- Streak calculations
- Date utilities
- Validation rules

Ditambah **mocktail** untuk mock repository Supabase.

## 14.2 Component / Widget Testing

**flutter_test (WidgetTester)**

Gunakan untuk widget reusable penting dan perilaku screen.

## 14.3 End-to-End Testing

**integration_test — Optional**

Pertimbangkan untuk flow utama bila jadwal memungkinkan:

```text
Register → Login → Home
Create Task → Complete Task
Start Focus → Finish Session
Add Mood → View History
Create Habit → Log Habit
```

Untuk MVP semester, unit + widget testing diprioritaskan sebelum E2E penuh.

---

# 15. Code Quality & Formatting

| Tool | Status | Purpose |
|---|---:|---|
| **dart analyze** | ✅ Proposed | Static code analysis |
| **dart format** | ✅ Proposed | Consistent formatting |
| **very_good_analysis** | ✅ Proposed | Strict lint rules (pengganti ESLint+Prettier) |
| **Husky / lefthook** | Optional | Git hooks |

Minimum quality gate sebelum merge:

```text
dart analyze
dart format --set-exit-if-changed .
flutter test relevan
```

---

# 16. Version Control

## Git + GitHub

Recommended workflow:

```text
main
└── develop
    ├── feature/auth
    ├── feature/home
    ├── feature/planner
    ├── feature/focus
    ├── feature/wellness
    └── feature/profile
```

Strategi branch boleh disederhanakan bila tim kecil.

### Commit convention

```text
feat: add planner task creation
feat: add mood tracking
fix: correct focus timer reset
refactor: extract task card widget
docs: update technical specification
test: add focus timer tests
```

---

# 17. Build & Deployment

## Flutter CLI + GitHub Actions (opsional: Codemagic)

Gunakan untuk build dan artefak rilis.

Possible environments:

```text
development (--flavor dev)
preview
production
```

Perintah dasar:

```text
flutter build apk --release        # Android testing
flutter build appbundle --release  # Play Store
flutter build ipa --release        # iOS (butuh macOS + Xcode)
```

Target pertama bisa **Android** bila sesuai lingkungan penilaian semester. iOS tetap didukung via arsitektur cross-platform.

Environment: Flutter SDK + Android Studio (SDK + Emulator) + Xcode (untuk iOS).

---

# 18. Environment Variables

Gunakan environment variables / compile-time define untuk konfigurasi yang tidak boleh di-hardcode.

Contoh dengan `--dart-define`:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xyz.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=...
```

Atau file `.env` via package `flutter_dotenv` (jangan commit file asli):

```text
.env.example  → commit
.env          → jangan commit
```

---

# 19. Recommended Project Structure

```text
florea/
│
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── app.dart
│   │   └── router.dart          # go_router config
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── login_page.dart
│   │   │   ├── register_page.dart
│   │   │   ├── forgot_password_page.dart
│   │   │   └── onboarding_page.dart
│   │   ├── home/
│   │   │   └── home_page.dart
│   │   ├── planner/
│   │   │   ├── planner_page.dart
│   │   │   ├── create_task_page.dart
│   │   │   ├── edit_task_page.dart
│   │   │   └── task_detail_page.dart
│   │   ├── focus/
│   │   │   ├── focus_page.dart
│   │   │   ├── pomodoro_page.dart
│   │   │   ├── deep_focus_page.dart
│   │   │   ├── exam_mode_page.dart
│   │   │   └── focus_history_page.dart
│   │   ├── wellness/
│   │   │   ├── wellness_page.dart
│   │   │   ├── mood_page.dart
│   │   │   ├── sleep_page.dart
│   │   │   ├── habits_page.dart
│   │   │   ├── eye_rest_page.dart
│   │   │   ├── mini_walk_page.dart
│   │   │   └── quick_stretch_page.dart
│   │   └── profile/
│   │       └── profile_page.dart
│   │
│   ├── widgets/                 # reusable UI
│   │   ├── app_button.dart
│   │   ├── app_card.dart
│   │   └── task_card.dart
│   │
│   ├── providers/               # Riverpod
│   │   ├── auth_provider.dart
│   │   ├── task_provider.dart
│   │   ├── focus_provider.dart
│   │   ├── wellness_provider.dart
│   │   └── settings_provider.dart
│   │
│   ├── repositories/            # Supabase queries
│   │   ├── auth_repository.dart
│   │   ├── task_repository.dart
│   │   └── ...
│   │
│   ├── services/
│   │   ├── supabase_client.dart
│   │   └── notification_service.dart
│   │
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text.dart
│   │   │   └── app_theme.dart
│   │   └── validators/
│   │
│   ├── models/                  # DTO / entity (json_serializable bila perlu)
│   │
│   ├── utils/
│   │
│   ├── l10n/                    # lokalisasi bila perlu
│   │
│   └── assets/
│       ├── images/
│       ├── icons/
│       └── sounds/
│
├── supabase/
│   ├── migrations/
│   └── functions/
│
├── test/                        # unit + widget test
├── integration_test/            # E2E opsional
│
├── .env.example
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

---

# 20. AI-Assisted Development / Vibe Coding

## Development model

Floréa akan dikembangkan dengan bantuan **OpenCode / AI coding agent**.

Agent tidak boleh membuat keputusan arsitektur besar secara otomatis tanpa mengikuti dokumen proyek yang sudah dikonfirmasi.

### Source of truth

Prioritas referensi:

```text
1. Confirmed project specification
2. Confirmed Figma UI/UX
3. Database / API specification
4. Coding rules
5. Agent implementation details
```

### Agent principles

1. **Do not change the technology stack without approval.**
2. **Do not invent features that are not specified.**
3. **Do not replace existing Figma UI with an unrelated design.**
4. **Use reusable widgets.**
5. **Keep page files focused on presentation and interaction.**
6. **Keep business logic in repositories/providers/services/utils where appropriate.**
7. **Keep backend queries separated from UI widgets.**
8. **Use Dart null-safety and strong types instead of `dynamic` whenever practical.**
9. **Do not hardcode secrets.**
10. **Run analyze, format, and relevant tests after changes.**
11. **Make small, reviewable changes instead of rewriting large sections unnecessarily.**
12. **Ask for confirmation before introducing a new package when an existing dependency can solve the problem.**

---

# 21. AI Agent Guardrails

Before implementing a feature, the agent should identify:

```text
Feature
↓
Required page(s)
↓
Required widget(s)
↓
Required state (provider)
↓
Required repository/API
↓
Required database table(s)
↓
Validation
↓
Loading / Error / Empty state
↓
Test requirement
```

The agent should not skip directly from:

```text
Figma → code
```

when the feature requires persistent data or backend logic.

---

# 22. Explicitly Out of Scope for Initial MVP

Unless the project specification later adds them, do not introduce these technologies/features by default:

```text
React Native / Expo / NativeWind
Redux
Node.js + Express separate backend
MongoDB
GraphQL
Redis
Docker / Kubernetes
Microservices
Firebase alongside Supabase (kecuali FCM bila terbukti perlu)
LLM / AI integration
Complex realtime architecture
Bloc / GetX (gunakan Riverpod agar konsisten)
```

This is intended to keep the semester project maintainable and focused on the documented Floréa feature set.

---

# 23. Final Proposed Stack Snapshot

```text
========================================
FLORÉA TECH STACK (FLUTTER)
========================================

Language
→ Dart

Mobile
→ Flutter
→ go_router

UI
→ Material 3 Theme
→ google_fonts (Fraunces + DM Sans)
→ lucide_icons
→ flutter_svg
→ flutter_animate
→ SafeArea (built-in)

State
→ flutter_riverpod

Network
→ Dio (bila perlu REST custom)
→ supabase_flutter

Backend
→ Supabase

Database
→ PostgreSQL

Auth
→ Supabase Auth (Google OAuth ditunda)

Security
→ Row Level Security
→ flutter_secure_storage

Storage
→ Supabase Storage (when needed)

Server Functions
→ Supabase Edge Functions (when needed)

Notifications
→ flutter_local_notifications

Forms
→ Form built-in
→ form_builder_validators

Charts
→ fl_chart

Date / Time
→ intl

Testing
→ flutter_test
→ mocktail
→ integration_test (optional)

Code Quality
→ dart analyze
→ dart format
→ very_good_analysis

Version Control
→ Git
→ GitHub

Build
→ flutter build apk/appbundle/ipa
→ GitHub Actions (opsional: Codemagic)

Design
→ Figma
→ Fraunces
→ DM Sans

AI Development
→ OpenCode / Vibe Coding Agent
========================================
```

---

# 24. Confirmation Checklist for OpenCode

Please confirm the following before project initialization:

- [ ] Flutter
- [ ] Dart
- [ ] go_router
- [ ] Material 3 Theme + google_fonts
- [ ] lucide_icons + flutter_svg
- [ ] flutter_riverpod
- [ ] supabase_flutter
- [ ] PostgreSQL
- [ ] Supabase Auth
- [ ] Row Level Security
- [ ] flutter_local_notifications
- [ ] shared_preferences
- [ ] flutter_secure_storage
- [ ] form_builder_validators
- [ ] intl
- [ ] fl_chart
- [ ] flutter_test
- [ ] dart analyze + dart format
- [ ] Git + GitHub
- [ ] flutter build + EAS-pengganti (GitHub Actions/Codemagic)
- [ ] OpenCode / AI coding agent

---

# 25. Next Technical Documents

After this stack is confirmed, the recommended next documents are:

```text
01. SYSTEM_ARCHITECTURE.md
02. DATABASE_ERD.md
03. DATABASE_SCHEMA.md
04. API_SPECIFICATION.md
05. AUTH_FLOW.md
06. NAVIGATION_FLOW.md
07. DESIGN_SYSTEM.md
08. FEATURE_SPECIFICATION.md
09. CODING_RULES.md
10. DEVELOPMENT_ROADMAP.md
```

These documents should be created before asking the agent to implement the complete application.

---

## Source / Basis

The feature list, product purpose, target users/stakeholders, design typography, and documented color values in this document are based on the Floréa project board and UI/UX mockup supplied with the project. Implementation technologies are now Flutter/Dart decisions for the project and should be treated as **pending confirmation** until approved by the project team.

## Changelog

- Revisi: base diganti dari React Native + Expo + TypeScript menjadi Flutter + Dart + go_router per permintaan tim.
- UI: NativeWind → Material 3 Theme + google_fonts; Lucide RN → lucide_icons; Reanimated → flutter_animate.
- State: Zustand → flutter_riverpod; TanStack Query → Riverpod AsyncNotifier + supabase_flutter/Dio.
- Form: RHF+Zod → Form + form_builder_validators.
- Notif: Expo Notifications → flutter_local_notifications.
- Lokal: AsyncStorage → shared_preferences; Secure Store → flutter_secure_storage.
- Chart: Gifted Charts → fl_chart. Date: date-fns → intl.
- Test: Jest/RNTL/Detox → flutter_test + mocktail + integration_test.
- Quality: ESLint/Prettier → dart analyze/format + very_good_analysis. Build: EAS → flutter build.
