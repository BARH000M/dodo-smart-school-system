import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/dodo_app.dart';
import 'core/backend.dart';
export 'app/dodo_app.dart';
export 'core/backend.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (configured) await Supabase.initialize(url: url, anonKey: key);
  final specs = asRows(jsonDecode(await rootBundle.loadString('assets/modules.json')));
  runApp(DodoApp(specs: specs));
}
