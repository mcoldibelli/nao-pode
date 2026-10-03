import 'package:flutter/material.dart';
import 'package:projeto/ui/tela_configuracao.dart';
import 'package:projeto/ui/tela_tutorial.dart';

import '../domain/loja.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key, required this.loja});

  final Loja loja;

  void _abrir(BuildContext context, Widget tela) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Não Pode')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Faça seu time adivinhar a palavra sem falar as proibidas.',
            ),
            ElevatedButton(
              onPressed: () => _abrir(context, TelaConfiguracao(loja: loja)),
              child: const Text('Jogar'),
            ),
            TextButton(
              onPressed: () => _abrir(context, const TelaTutorial()),
              child: const Text('Como jogar'),
            ),
          ],
        ),
      ),
    );
  }
}
