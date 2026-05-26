import 'package:flutter/material.dart';
import 'package:flutter_aplication_bank/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders bank home modules', (WidgetTester tester) async {
    await tester.pumpWidget(const BancoDigitalApp());

    expect(find.text('Banco Digital Kaua'), findsOneWidget);
    expect(find.text('Saldo disponível'), findsOneWidget);
    expect(find.text('Conta'), findsOneWidget);
    expect(find.text('Transações'), findsOneWidget);
    expect(find.text('Pix'), findsOneWidget);
    expect(find.text('Cartões'), findsOneWidget);
  });

  testWidgets('navigates to Pix module', (WidgetTester tester) async {
    await tester.pumpWidget(const BancoDigitalApp());

    await tester.tap(find.byIcon(Icons.pix));
    await tester.pumpAndSettle();

    expect(
      find.text('Tela reservada para chaves, pagamentos e transferências Pix.'),
      findsOneWidget,
    );
  });
}
