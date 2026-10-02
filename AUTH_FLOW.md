# Floréa — Auth Flow (Supabase + Flutter)

> Stack: `supabase_flutter` + `GetX` (`GetMaterialApp` + `AuthMiddleware` + `AuthController`)
> Terkait: `FEATURE_SPECIFICATION.md` (F1/F2), `DATABASE_SCHEMA.md` (profiles, user_goals)

## 1. Mode Auth yang Didukung (MVP)

```text
P0: Register (email+password) → Verifikasi email → Login → Onboarding → Home
P0: Login → Home (bila onboarding_completed = true) atau → Onboarding
P0: Forgot Password → Email reset link → Login
P0: Logout (clear session + ke /login)
P1: Google OAuth (ditunda — butuh SHA-1 Android + OAuth Client ID)
```

## 2. Diagram Alur

```text
App start
  → Supabase.initialize
  → cek session
  ├─ ada session + profiles.onboarding_completed = true  → /main
  ├─ ada session + onboarding_completed = false          → /onboarding
  └─ tidak ada session                                   → /login

/login ──(belum punya akun)──> /register ──> /verify ──> /login
/login ──(lupa password)─────> /forgot-password ──(link email)──> /login
/login ──(sukses + onboarding false)──> /onboarding ──(simpan goal + initial mood)──> /main
```

## 3. Detail per Screen

### 3.1 `/register` — Create Account
Input: name, email, password, confirm password, user goal/interest (opsional, bisa diisi di onboarding).
Proses:
1. Validasi lokal (email valid, password ≥ 8, confirm sama).
2. `supabase.auth.signUp(email, password)`.
3. Insert `profiles(id=auth.uid, full_name=name, email)` — via trigger atau dari client sekali.
4. Arahkan ke `/verify` (info: cek email).

### 3.2 `/verify` — Verification Code
Supabase default memakai **email link** (bukan kode 6 digit). Dua opsi:
- **Opsi A (disarankan MVP):** instruksikan user klik link di email → session terbentuk → redirect sesuai §2.
- **Opsi B:** aktifkan OTP 6-digit di Supabase Auth → input kode di screen ini → `verifyOTP`.
Tim pilih A dulu kecuali board mewajibkan kode.

### 3.3 `/login`
Input: email/username + password. (Username = P2; MVP hanya email — kolom username tidak ada di schema.)
Proses: `signInWithPassword` → baca `profiles.onboarding_completed` → redirect §2.
Error umum: `Invalid login credentials`, `Email not confirmed` → tampilkan pesan + tombol kirim ulang verifikasi.

### 3.4 `/forgot-password`
Input email → `resetPasswordFor(email, redirectTo: <deep-link>)` → toast "link terkirim".
Reset password finalisasi di browser/webview, lalu user login ulang di app.

### 3.5 `/onboarding`
Langkah: (1) user goal → insert `user_goals`, (2) wellness goal → insert `user_goals` kedua atau kolom di profiles (pilih: tabel `user_goals`, bedakan via kolom `kind` bila perlu — tambah hanya jika disetujui),
(3) initial mood → insert 1 baris `mood_logs`.
Tombol Selesai → `profiles.onboarding_completed = true` → `/main`.
Onboarding bisa di-skip? **Tidak untuk MVP** — flag harus true agar Home punya data awal. Tombol Lewati hanya bila tim setuju (tambah backlog).

## 4. Session & Protected Route (GetX AuthMiddleware)

```dart
// lib/app/middlewares/auth_middleware.dart
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>(); // isLoggedIn + onboardingDone (cache profiles)
    final goingAuth = route == Routes.login || route == Routes.register;
    if (!auth.isLoggedIn.value && !goingAuth) return const RouteSettings(name: Routes.login);
    if (auth.isLoggedIn.value && !auth.onboardingDone.value && route != Routes.onboarding) {
      return const RouteSettings(name: Routes.onboarding);
    }
    if (auth.isLoggedIn.value && auth.onboardingDone.value && goingAuth) {
      return const RouteSettings(name: Routes.main);
    }
    return null;
  }
}
```

- Refresh session: `supabase.auth.onAuthStateChange` → update `AuthController`.
- Token disimpan aman oleh SDK; data sensitif tambahan → `flutter_secure_storage`.
- Logout: `signOut()` → reset controller → `Get.offAllNamed(Routes.login)`.

## 5. RLS Terkait Auth

- `profiles`: policy `auth.uid() = id` (lihat SCHEMA §1). Insert profil hanya untuk `id` sendiri.
- Semua tabel user-data: `auth.uid() = user_id`.

## 6. Error / Edge Cases

| Kasus | Penanganan |
|---|---|
| Email belum verifikasi saat login | Pesan + tombol "Kirim ulang" |
| Session kedaluwarsa | Redirect `/login` + toast |
| User hapus app lalu install ulang | Session hilang → login ulang, data aman di Supabase |
| Double submit register | Disable tombol saat loading |

## 7. Test Minimal

- Unit: validator email/password/confirm.
- Widget: register mismatch ditolak, login sukses → redirect /main (mock controller).
- Manual: register → verify → onboarding → home → logout → login.

## 8. Yang Ditunda (P1/P2)

- Google OAuth (`google_sign_in` + Supabase) — butuh config Android/iOS.
- Username login (butuh kolom + lookup tambahan).
- Biometrik (local_auth) — P2.
