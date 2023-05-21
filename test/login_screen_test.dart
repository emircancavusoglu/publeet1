import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:publeet1/login_screen.dart';
import 'package:publeet1/selection_screen.dart';

void main() {
      testWidgets('Login button should navigate to SelectionScreen when username and password are provided', (WidgetTester tester) async {
            await tester.pumpWidget(
                  MaterialApp(
                        home: LoginScreen(),
                  ),
            );

            final userNameField = find.byType(TextField).first;
            final passwordField = find.byType(TextField).last;
            final loginButton = find.text('Giriş Yap');

            await tester.enterText(userNameField, 'testuser');
            await tester.enterText(passwordField, 'testpassword');
            await tester.tap(loginButton);
            await tester.pumpAndSettle();

            expect(find.byType(SelectionScreen), findsOneWidget);
      });

      testWidgets('Login button should show an alert dialog when username or password is empty', (WidgetTester tester) async {
            await tester.pumpWidget(
                  const MaterialApp(
                        home: LoginScreen(),
                  ),
            );

            final loginButton = find.text('Giriş Yap');

            await tester.tap(loginButton);
            await tester.pumpAndSettle();

            expect(find.byType(AlertDialog), findsOneWidget);
      });

      // Add more test cases for other scenarios if needed
}
