# Floréa — Navigation Flow (GetX)

> Terkait: `FEATURE_SPECIFICATION.md`, `AUTH_FLOW.md`
> Pola: `GetMaterialApp` + `GetPage` (`app_pages.dart`) + `AuthMiddleware` + `MainShell` (IndexedStack).
> Satu sistem router saja — `go_router` dilarang agar tidak dobel.

## 1. Struktur Navigasi

```text
(auth) — tanpa tab bar
  /login /register /forgot-password /verify /onboarding

(main shell) — MainShell: IndexedStack + BottomNavigationBar, 5 tab sesuai board
  tab 0 Home · tab 1 Planner · tab 2 Focus · tab 3 Wellness · tab 4 Profil

detail (push di atas stack aktif via Get.toNamed)
  /planner/create /planner/detail/:id /planner/edit/:id
  /focus/pomodoro /focus/deep /focus/exam /focus/history
  /wellness/mood /wellness/habits /wellness/sleep
  /profile/edit /profile/settings /profile/achievements
```

Urutan tab disarankan mengikuti Figma: Home, Planner, Focus, Wellness, Profile.
Ikon tab: `lucide_icons` (Home, CalendarDays, Timer, HeartPulse, User).
Pindah tab = `MainController.to.goTab(i)` (tidak menumpuk route); halaman detail = `Get.toNamed(...)`.

## 2. Tabel Route ↔ Board

| Board (POV User) | Route | Tab? |
|---|---|---|
| Login/Register/Onboarding, Create Account | `/login /register /forgot-password /verify /onboarding` | bukan tab (guard middleware, lihat AUTH_FLOW) |
| Home Dashboard | `/main` tab 0 | ya |
| Planner Dashboard + status task | `/main` tab 1 + detail planner | ya |
| Focus Dashboard | `/main` tab 2 + mode/history | ya |
| Wellness Dashboard | `/main` tab 3 + sub-pages | ya |
| Profile Dashboard | `/main` tab 4 + edit/settings/achievements | ya |

## 3. Alur Kunci

### 3.1 Cold start → tab
Splash (`AuthController` cek session saat init) → middleware redirect (AUTH_FLOW §4) → `/main` (tab 0) atau `/onboarding` atau `/login`.
State tab tidak perlu persist untuk MVP (kembali ke tab 0 tiap restart).

### 3.2 Quick Action (Home)
`+ Task` → `Get.toNamed('/planner/create')` · `Mulai Fokus` → `goTab(2)` · `Catat Mood` → bottom sheet (`Get.bottomSheet`, tanpa pindah route).
Setelah simpan: `Get.back()` + snackbar + `Get.find<TaskController>().refreshData()`.

### 3.3 Planner
List → tap item → `Get.toNamed('/planner/detail/123')` → Edit → `Get.toNamed('/planner/edit/123')` → simpan → `Get.back()` / `Get.offNamed` kembali ke list.
Filter status (Upcoming/In Progress/Completed) = Rx state lokal di `TaskController`, bukan route terpisah (hindari duplikasi history).

### 3.4 Focus
Tab Focus → pilih mode → `Get.toNamed('/focus/pomodoro')` → timer jalan di `FocusController` → selesai → dialog ringkasan (`Get.dialog`) → History.
Tombol back saat timer jalan → dialog konfirmasi "Batalkan sesi?" (sesi tersimpan `cancelled` bila sudah > 1 menit, sesuai kesepakatan tim).

### 3.5 Notifikasi → deep link
Tap notif task/deadline → `/planner/detail/:id`; habit → `/wellness/habits`; sleep/wellness → `/wellness`.
Implementasi di `notification_service` + `Get.toNamed` (payload berisi route).

## 4. Aturan Umum

1. **Auth guard** di `AuthMiddleware` (jangan cek session di tiap page).
2. Detail selalu `Get.toNamed`, pindah tab selalu `goTab`/`offAllNamed` (tidak menumpuk stack).
3. Tutup auth flow dengan `Get.offAllNamed` (login → main, logout → login) agar back tidak kembali ke form.
4. Form kotor (unsaved changes) → dialog konfirmasi sebelum `Get.back()`.
5. Transisi: default GetX; animasi khusus (`flutter_animate`) hanya untuk Figma-flagged transitions.
6. Back Android: keluar app hanya dari `/main`; dari detail → kembali ke stack sebelumnya.
7. DI hanya via `Bindings`; dilarang `Get.put` di dalam widget.

## 5. Struktur File Routing

```dart
// Tetap di lib/app/. Jangan pecah route per fitur untuk MVP.
app_routes.dart       // konstanta Routes.*
app_pages.dart        // List<GetPage> + middlewares + bindings
main_shell.dart       // IndexedStack 5 tab
middlewares/auth_middleware.dart
bindings/app_bindings.dart
```

## 6. Pemetaan Prototype Figma

Begitu folder export Figma tersedia, isi tabel ini (1 baris per screen Figma):

```text
| Screen Figma | Route GetX | File Dart | Status |
| Splash | /login (redirect) | ... | TODO |
```

Saya yang konversi HTML/CSS → Widget per screen mengikuti tabel ini.
