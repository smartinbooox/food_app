import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/env_constants.dart';

void main() async {
  // supabase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: EnvConstants.supabaseUrl,
    anonKey: EnvConstants.supabaseAnonKey,
  );

  runApp(const MyApp());
}

import 'app.dart';

void main() async {
  // supabase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: EnvConstants.supabaseUrl,
    anonKey: EnvConstants.supabaseAnonKey,
  );

  runApp(const App());
}
