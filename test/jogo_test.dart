import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto/data/baralhos.dart';
import 'package:projeto/ui/estilo.dart';
import 'package:projeto/ui/sons.dart';
import 'package:projeto/ui/tela_ajustes.dart';
import 'package:projeto/ui/tela_inicial.dart';

void main() {
  setUp(() {
    tocarSom = (_) {};
    baralhoEscolhido.value = baralhos.first;
  });

  for (final brilho in Brightness.values) {
    testWidgets(
      'escolhe o baralho nas configurações e joga até o fim ($brilho)',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: temaDoApp(brilho),
            home: const TelaInicial(nome: 'Ana'),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.text('Oi, Ana! Vamos de Sustentabilidade e mobilidade?'),
          findsOneWidget,
        );

        await tester.tap(find.byTooltip('Configurações'));
        await tester.pumpAndSettle();
        expect(find.text('Cidadania e inclusão'), findsOneWidget);
        await tester.tap(find.text('Saúde'));
        await tester.pumpAndSettle();
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.text('Oi, Ana! Vamos de Saúde?'), findsOneWidget);

        await tester.tap(find.text('Jogar'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(AppBar, 'Saúde'), findsOneWidget);

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
            expect(find.text('Boa! +1 ponto'), findsOneWidget);
          }
          await tester.pump(const Duration(seconds: 60));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Continuar'));
          await tester.pumpAndSettle();
        }

        expect(find.text('Fim de jogo'), findsOneWidget);
        expect(find.text('Time A venceu!'), findsOneWidget);
      },
    );
  }
}
