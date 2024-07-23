import 'package:flutter_test/flutter_test.dart';
import 'package:soremar_inventory/main.dart';
import 'package:soremar_inventory/screens/NFCUnavailablepage.dart';
import 'package:soremar_inventory/screens/home_page.dart';

void main() {
  testWidgets('Initial route test', (WidgetTester tester) async {
    // Mock NFC availability
    bool nfcAvailable = false; // Assume NFC is not available initially

    // Wrap the app initialization in an async closure
    await tester.runAsync(() async {
      // Use a Future.delayed to simulate asynchronous NFC availability check
      Future.delayed(Duration.zero, () async {
        // Simulate NFC being available or not based on a condition
        nfcAvailable = await someConditionToCheckNFC();

        // Build our app and trigger a frame.
        await tester.pumpWidget(MyApp(nfcAvailable: nfcAvailable));
      });

      // Wait for the next frame after pumpWidget
      await tester.pump();

      // Verify that the correct initial route is shown
      if (nfcAvailable) {
        expect(find.byType(HomePage), findsOneWidget);
        expect(find.byType(ErrorPage), findsNothing);
      } else {
        expect(find.byType(HomePage), findsNothing);
        expect(find.byType(ErrorPage), findsOneWidget);
      }
    });
  });
}

// Simulate an asynchronous NFC availability check
Future<bool> someConditionToCheckNFC() async {
  // Simulate a condition where NFC is available or not
  return Future.value(true); // Replace with actual logic to check NFC
}