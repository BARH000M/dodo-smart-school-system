import 'package:flutter_test/flutter_test.dart';
import 'package:dodo_smart_school_system/main.dart';
void main() {
  testWidgets('unconfigured app displays setup state without connecting', (tester) async {
    if (configured) return;
    await tester.pumpWidget(const DodoApp(specs: []));
    await tester.pumpAndSettle();
    expect(find.text('DODO'), findsOneWidget);
  });
}
