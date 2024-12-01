
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_pro_water_reminder/src/presentation/screens/auth/login_screen.dart'; // Import the correct path to LoginScreen
import 'package:mini_pro_water_reminder/main.dart'; // Your main app entry point

void main() {
  testWidgets('Splash screen transition test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const WaterReminderApp());

    // Verify that SplashScreen is displayed
    expect(find.text('Stay Hydrated, Stay Healthy'), findsOneWidget);

    // Wait for 8 seconds (simulating the delay for splash screen transition)
    await tester.pumpAndSettle(const Duration(seconds: 8));

    // After the delay, verify that LoginScreen is shown
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
