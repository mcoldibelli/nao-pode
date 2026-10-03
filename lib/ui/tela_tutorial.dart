import 'package:flutter/material.dart';

const _regras = [
  ('Times', 'Dois times jogam em turnos. Quem explica segura o celular.'),
  ('Proibidas', 'Explique a palavra da carta sem falar as cinco proibidas.'),
  ('Acertou', 'O time adivinhou: +1 ponto.'),
  ('Errou', 'Falou uma proibida: -1 ponto.'),
  (
    'Pulou',
    'Troca a carta sem pontos. O número de pulos por turno é limitado.',
  ),
  ('Fim', 'Depois das rodadas, o time com mais pontos vence.'),
];

class TelaTutorial extends StatelessWidget {
  const TelaTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Como jogar')),
      body: ListView(
        children: [
          for (final (titulo, texto) in _regras)
            ListTile(title: Text(titulo), subtitle: Text(texto)),
        ],
      ),
    );
  }
}
