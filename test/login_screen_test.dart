import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:publeet1/login_screen.dart';
import 'package:publeet1/selection_screen.dart';

void main() {
      testWidgets("Kullanıcı adı ve parola sağlandığında oturum açma butonu SelectionScreen'e gitmelidir.", (WidgetTester tester) async {
            await tester.pumpWidget(
                  const MaterialApp(
                        home: LoginScreen(),
                  ),
            );

            final userNameField = find.byType(TextField).first;
            final passwordField = find.byType(TextField).last;
            final loginButton = find.text('Giriş Yap');

            await tester.enterText(userNameField, 'testuser');
            await tester.enterText(passwordField, 'testpassword');
            await tester.tap(loginButton);
            await tester.pumpAndSettle(); //ekran geçişini bekler

            expect(find.byType(SelectionScreen), findsOneWidget);
      });

      testWidgets('Oturum açma butonu, kullanıcı adı veya parola boş olduğunda bir uyarı göstermelidir', (WidgetTester tester) async {
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
}
