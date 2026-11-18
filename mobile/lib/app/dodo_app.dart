import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/backend.dart';
import '../features/auth/login.dart';
import '../features/workspace/workspace.dart';
class DodoApp extends StatefulWidget {
  const DodoApp({super.key, required this.specs});
  final List<RowData> specs;
  @override State<DodoApp> createState() => _DodoAppState();
}
class _DodoAppState extends State<DodoApp> {
  bool ar = true;
  Session? session;
  StreamSubscription<AuthState>? subscription;
  @override void initState() {
    super.initState();
    if (configured) {
      session = db.auth.currentSession;
      subscription = db.auth.onAuthStateChange.listen((state) {
        if (mounted) setState(() => session = state.session);
      });
    }
  }
  @override void dispose() { subscription?.cancel(); super.dispose(); }
  @override Widget build(BuildContext context) => MaterialApp(
    key: ValueKey(session?.user.id ?? 'signed-out'),
    title: 'DODO SMART SCHOOL SYSTEM', debugShowCheckedModeBanner: false,
    locale: Locale(ar ? 'ar' : 'en'), supportedLocales: const [Locale('ar'), Locale('en')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff173b70)), scaffoldBackgroundColor: const Color(0xfff3f6fb)),
    home: !configured ? Scaffold(appBar: AppBar(title: const Text('DODO')), body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(tr(ar,'اضبط اتصال Supabase عند البناء.','Set the Supabase URL and publishable key at build time.'))))) :
      session == null ? Login(ar: ar, toggle: () => setState(() => ar = !ar)) :
      Workspace(key: ValueKey(session!.user.id), ar: ar, specs: widget.specs, toggle: () => setState(() => ar = !ar)),
  );
}
