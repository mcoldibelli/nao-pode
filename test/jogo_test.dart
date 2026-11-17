import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto/data/baralhos.dart';
import 'package:projeto/domain/configuracao.dart';
import 'package:projeto/ui/estilo.dart';
import 'package:projeto/ui/sons.dart';
import 'package:projeto/ui/tela_ajustes.dart';
import 'package:projeto/ui/tela_inicial.dart';

void main() {
  setUp(() {
    tocarSom = (_) {};
    configuracaoDaPartida.value = Configuracao(
      nomeTimeA: 'Time A',
      nomeTimeB: 'Time B',
      baralho: baralhos.first,
    );
  });

  for (final brilho in Brightness.values) {
    testWidgets(
      'configura a partida nas configurações e joga até o fim ($brilho)',
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
        await tester.tap(find.text('Saúde'));
        await tester.pumpAndSettle();

        final lista = find.byType(Scrollable).first;
        final time1 = find.widgetWithText(TextFormField, 'Time 1');
        await tester.scrollUntilVisible(time1, 100, scrollable: lista);
        await tester.enterText(time1, ' ');
        await tester.pump();
        expect(find.text('Informe o nome do time'), findsOneWidget);
        await tester.enterText(time1, 'Time B');
        await tester.pump();
        expect(
          find.text('Os times precisam de nomes diferentes'),
          findsWidgets,
        );
        await tester.enterText(time1, 'Leões');
        await tester.pump();

        final rodadas = find.byKey(const ValueKey('rodadas'));
        await tester.scrollUntilVisible(rodadas, 100, scrollable: lista);
        await tester.tap(
          find.descendant(of: rodadas, matching: find.text('1')),
        );
        await tester.pumpAndSettle();
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.text('Oi, Ana! Vamos de Saúde?'), findsOneWidget);

        await tester.tap(find.text('Jogar'));
        await tester.pumpAndSettle();
        expect(find.text('Rodada 1 de 1'), findsOneWidget);
        expect(find.text('Vez de: Leões'), findsOneWidget);

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
        expect(find.text('Leões venceu!'), findsOneWidget);
      },
    );
  }
}
