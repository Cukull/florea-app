import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // TODO: await initSupabase(url: ..., anonKey: ...) setelah .env diisi
  runApp(const FloreaApp());
}
