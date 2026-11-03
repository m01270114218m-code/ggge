import 'package:flutter_test/flutter_test.dart';
import 'package:vox_royale/main.dart';

void main() {
  testWidgets('renders the Arabic-first VOX ROYALE discovery shell', (tester) async {
    await tester.pumpWidget(const VoxRoyaleApp());
    expect(find.text('VOX ROYALE'), findsOneWidget);
    expect(find.text('غرف مختارة'), findsOneWidget);
    expect(find.text('اكتشف'), findsWidgets);
  });
}
