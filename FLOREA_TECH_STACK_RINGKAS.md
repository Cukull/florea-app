# Floréa — Ringkasan Tech Stack (Untuk Persetujuan Kelompok)

> Status: Proposal — mohon persetujuan sebelum coding dimulai
> Project: Floréa — Balance Your Mind, Study & Life
> Base: Flutter + Dart (revisi dari React Native)
> Sumber: FLOREA_TECH_STACK.md + Project Board + Desain UI/UX

## 1. Konteks Singkat
Aplikasi mobile untuk mahasiswa agar seimbang antara akademik dan kesehatan mental.
Fitur inti: Login/Register/Onboarding, Home, Planner (task, deadline, kalender), Focus (Pomodoro, Deep Focus, Exam Mode), Wellness (mood, habit, sleep, hidrasi, eye-rest, stretch), Statistik, Achievement, Notifikasi, Profile.

Design system: Fraunces (heading) + DM Sans (body). Warna contoh sementara (JANGAN DIKUNCI, diganti saat dev): `#FAF7F2`, `#8B7CF8`, `#EAF7FC`.

## 2. Tech Stack yang Diusulkan (Flutter)

| Kategori | Teknologi |
|---|---|
| Mobile | Flutter + Dart + go_router |
| UI | Material 3 Theme, google_fonts, lucide_icons, flutter_svg, flutter_animate |
| State | flutter_riverpod (UI lokal + server via AsyncNotifier) |
| Backend | Supabase (Auth, PostgreSQL, RLS, Storage, Edge Functions) |
| Network | supabase_flutter (+ Dio bila perlu REST custom) |
| Form | Form built-in + form_builder_validators |
| Notifikasi | flutter_local_notifications |
| Lokal | shared_preferences + flutter_secure_storage |
| Chart | fl_chart |
| Tanggal | intl + timezone |
| Testing | flutter_test + mocktail (integration_test opsional) |
| Kualitas | dart analyze + dart format + very_good_analysis |
| Repo | Git + GitHub |
| Build | flutter build apk/appbundle/ipa (target awal: Android) |
| Dev | OpenCode / AI-assisted |

Tidak dipakai untuk MVP: React Native/Expo, Bloc/GetX, Express, MongoDB, GraphQL, Firebase ganda, AI/LLM.

## 3. Rekomendasi

1. LAYAK DISETUJUI untuk tim yang pilih Dart — 1 codebase Android+iOS, performa bagus, tanpa backend sendiri.
2. CATATAN: Google OAuth, Realtime, E2E, Edge Functions ditunda sampai fitur inti (Planner, Focus Timer, Mood/Habit/Sleep) jalan.
3. Wajib sebelum coding: link Figma + ERD final + Auth Flow + Navigation Flow.

## 4. Checklist Persetujuan

- [ ] Flutter + Dart + go_router
- [ ] Material 3 + google_fonts + lucide_icons
- [ ] flutter_riverpod + supabase_flutter
- [ ] PostgreSQL + RLS + Supabase Auth
- [ ] flutter_local_notifications, fl_chart, intl
- [ ] dart analyze + format + GitHub + flutter build

Setuju / Revisi: _______________
Nama + TTD: _______________
