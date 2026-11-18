import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
void main(){
 TestWidgetsFlutterBinding.ensureInitialized();
 test('module contract contains no parent/student write grant',() async {
  final modules=jsonDecode(await rootBundle.loadString('assets/modules.json')) as List<dynamic>;
  expect(modules.length,49);
  for(final module in modules){
   final roles=module['write'] as List<dynamic>;
   expect(roles, isNot(contains('parent')));
   expect(roles, isNot(contains('student')));
  }
 });
}
