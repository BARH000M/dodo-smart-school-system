import 'package:supabase_flutter/supabase_flutter.dart';
typedef RowData = Map<String, dynamic>;
const url = String.fromEnvironment('SUPABASE_URL');
const key = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
final configured = url.isNotEmpty && key.isNotEmpty;
SupabaseClient get db => Supabase.instance.client;
List<RowData> asRows(dynamic value) => List<RowData>.from(value as List);
String label(RowData item, bool ar) => item[ar ? 'ar' : 'en'].toString();
String tr(bool ar, String a, String b) => ar ? a : b;
