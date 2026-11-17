import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto/ui/tela_inicial.dart';

void main() {
  testWidgets('os 3 baralhos ficam livres e uma partida vai até o fim', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TelaInicial()));
    await tester.tap(find.text('Jogar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sustentabilidade e mobilidade'));
    await tester.pumpAndSettle();
    expect(find.text('Saúde'), findsWidgets);
    expect(find.text('Cidadania e inclusão'), findsWidgets);
    await tester.tap(find.text('Saúde').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('3')); // valor atual de "Rodadas"
    await tester.pumpAndSettle();
    await tester.tap(find.text('1').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Começar'));
    await tester.pumpAndSettle();

    for (final acertos in [2, 0]) {
      await tester.tap(find.text('Começar turno'));
      await tester.pumpAndSettle();
      for (var i = 0; i < acertos; i++) {
        await tester.tap(find.text('Acertou'));
        await tester.pump();
      }
      await tester.pump(const Duration(seconds: 60));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
    }

    expect(find.text('Fim de jogo'), findsOneWidget);
    expect(find.text('Time A venceu!'), findsOneWidget);
    expect(find.textContaining('Moedas'), findsNothing);
  });
}
