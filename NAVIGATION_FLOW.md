# Floréa — Navigation Flow (go_router)

> Terkait: `FEATURE_SPECIFICATION.md`, `AUTH_FLOW.md`
> Router saat ini (`florea/lib/app/router.dart`) masih daftar `GoRoute` datar —
> naikkan ke `StatefulShellRoute` begitu bottom-tab Figma final.

## 1. Struktur Navigasi

```text
(auth) — tanpa tab bar
  /login /register /forgot-password /verify /onboarding

(tabs) — StatefulShellRoute, 5 tab sesuai board
  /home
  /planner
  /focus
  /wellness
  /profile

detail (stack di atas tab aktif)
  /planner/create /planner/:id /planner/:id/edit
  /focus/pomodoro /focus/deep /focus/exam /focus/history
  /wellness/mood /wellness/habits /wellness/sleep
  /profile/edit /profile/settings /profile/achievements
```

Urutan tab disarankan mengikuti Figma: Home, Planner, Focus, Wellness, Profile.
Ikon tab: `lucide_icons` (Home, CalendarDays, Timer, HeartPulse, User).

## 2. Tabel Route ↔ Board

| Board (POV User) | Route | Tab? |
|---|---|---|
| Login/Register/Onboarding, Create Account | `/login /register /forgot-password /verify /onboarding` | bukan tab (redirect auth, lihat AUTH_FLOW) |
| Home Dashboard | `/home` | tab 1 |
| Planner Dashboard + status task | `/planner…` | tab 2 |
| Focus Dashboard | `/focus…` | tab 3 |
| Wellness Dashboard | `/wellness…` | tab 4 |
| Profile Dashboard | `/profile…` | tab 5 |

## 3. Alur Kunci

### 3.1 Cold start → tab
Splash (`/`, tentukan di main) → redirect auth (AUTH_FLOW §4) → tab terakhir atau `/home`.
State tab tidak perlu persist untuk MVP (kembali ke `/home` tiap restart).

### 3.2 Quick Action (Home)
`+ Task` → `/planner/create` · `Mulai Fokus` → `/focus` · `Catat Mood` → bottom sheet di `/home` (tanpa pindah route).
Setelah simpan: `context.pop()` + snackbar + invalidate provider terkait.

### 3.3 Planner
List → tap item → `/planner/:id` → Edit → `/planner/:id/edit` → simpan → `pop` 2x kembali ke list (atau `go('/planner')`).
Filter status (Upcoming/In Progress/Completed) = state lokal tab, bukan route terpisah (hindari duplikasi history).

### 3.4 Focus
`/focus` → pilih mode → `/focus/{pomodoro,deep,exam}` → timer jalan → selesai → dialog ringkasan → History (`/focus/history`).
Tombol back saat timer jalan → dialog konfirmasi "Batalkan sesi?" (sesi tersimpan `cancelled` bila sudah > 1 menit, sesuai kesepakatan tim).

### 3.5 Notifikasi → deep link
Tap notif task/deadline → `/planner/:id`; habit → `/wellness/habits`; sleep/wellness → `/wellness`.
Skema: path + `id` sebagai parameter (lihat `notification_service` saat implementasi).

## 4. Aturan Umum

1. **Auth guard** di `redirect` (jangan cek session di tiap page).
2. Detail selalu `push` (`context.push`), pindah tab selalu `go` (tidak menumpuk stack).
3. Form kotor (unsaved changes) → `onExit`/dialog konfirmasi sebelum `pop`.
4. Transisi: default Material; animasi khusus (`flutter_animate`) hanya untuk Figma-flagged transitions.
5. Back Android: keluar app hanya dari tab root; dari detail → kembali ke tab.

## 5. Upgrade Router (TODO saat implementasi tab)

```dart
// Target: StatefulShellRoute.indexedStack dengan 5 branch.
// File tetap: lib/app/router.dart. Jangan pecah router per fitur untuk MVP.
```

## 6. Pemetaan Prototype Figma

Begitu folder export Figma tersedia, isi tabel ini (1 baris per screen Figma):

```text
| Screen Figma | Route | File Dart | Status |
| Splash | / | ... | TODO |
```

Saya yang konversi HTML/CSS → Widget per screen mengikuti tabel ini.
