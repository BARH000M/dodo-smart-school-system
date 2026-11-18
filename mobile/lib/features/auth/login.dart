import 'package:flutter/material.dart';
import '../../core/backend.dart';
class Login extends StatefulWidget {
  const Login({super.key, required this.ar, required this.toggle});
  final bool ar; final VoidCallback toggle;
  @override State<Login> createState() => _LoginState();
}
class _LoginState extends State<Login> {
  final email = TextEditingController(), password = TextEditingController();
  bool busy = false; String error = '';
  @override void dispose() { email.dispose(); password.dispose(); super.dispose(); }
  Future<void> signIn() async {
    setState(() {busy = true; error = '';});
    try { await db.auth.signInWithPassword(email: email.text.trim(), password: password.text); }
    catch (e) {if (mounted) setState(() => error = e.toString());}
    finally {if (mounted) setState(() => busy = false);}
  }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('DODO'), actions: [TextButton(onPressed: widget.toggle, child: Text(widget.ar?'English':'العربية'))]), body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    const Icon(Icons.school_outlined, size: 64, color: Color(0xff173b70)), const SizedBox(height: 18), const Text('DODO SMART SCHOOL SYSTEM', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), const SizedBox(height: 28),
    TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(border: const OutlineInputBorder(), labelText: tr(widget.ar,'البريد الإلكتروني','Email'))),const SizedBox(height: 12),
    TextField(controller: password, obscureText: true, decoration: InputDecoration(border: const OutlineInputBorder(),labelText: tr(widget.ar,'كلمة المرور','Password'))), const SizedBox(height: 12),
    FilledButton(onPressed: busy?null:signIn, child: Text(tr(widget.ar,'دخول','Sign in'))), if(error.isNotEmpty) Text(error,style: TextStyle(color: Theme.of(context).colorScheme.error)), if(busy) const LinearProgressIndicator(),
  ])))));
}
