import 'package:flutter_test/flutter_test.dart';
import 'package:vox_royale/main.dart';

void main() {
  testWidgets('renders Arabic discovery and navigable primary tabs', (tester) async {
    await tester.pumpWidget(const VoxRoyaleApp());
    expect(find.text('VOX ROYALE'), findsOneWidget);
    expect(find.text('غرف مقترحة'), findsOneWidget);
    await tester.tap(find.text('حسابي'));
    await tester.pumpAndSettle();
    expect(find.text('ملفي الشخصي'), findsOneWidget);
  });

  testWidgets('opens room preview and shows local room controls', (tester) async {
    await tester.pumpWidget(const VoxRoyaleApp());
    await tester.tap(find.text('مجلس السهرة').first);
    await tester.pumpAndSettle();
    expect(find.text('مقاعد المتحدثين'), findsOneWidget);
    expect(find.text('محادثة الغرفة'), findsOneWidget);
    expect(find.text('انضم'), findsOneWidget);
  });
}
