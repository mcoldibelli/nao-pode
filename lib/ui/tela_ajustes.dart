import 'package:flutter/material.dart';

import '../data/autenticacao.dart';
import '../data/baralhos.dart';
import '../domain/baralho.dart';
import '../domain/configuracao.dart';
import 'estilo.dart';

final modoDoTema = ValueNotifier(ThemeMode.system);
final configuracaoDaPartida = ValueNotifier(
  Configuracao(
    nomeTimeA: 'Time A',
    nomeTimeB: 'Time B',
    baralho: baralhos.first,
  ),
);

// Ícone e cor de cada baralho, na ordem de data/baralhos.dart.
const _aparencia = [
  (Icons.eco_rounded, turquesa),
  (Icons.favorite_rounded, rosa),
  (Icons.groups_rounded, sol),
];

class TelaAjustes extends StatefulWidget {
  const TelaAjustes({super.key, this.sair = sairDoFirebase});

  final Sair sair;

  @override
  State<TelaAjustes> createState() => _TelaAjustesState();
}

class _TelaAjustesState extends State<TelaAjustes> {
  final _times = GlobalKey<FormState>();
  final _timeA = TextEditingController(
    text: configuracaoDaPartida.value.nomeTimeA,
  );
  final _timeB = TextEditingController(
    text: configuracaoDaPartida.value.nomeTimeB,
  );

  @override
  void dispose() {
    _timeA.dispose();
    _timeB.dispose();
    super.dispose();
  }

  void _mudar(Configuracao Function(Configuracao atual) mudanca) {
    configuracaoDaPartida.value = mudanca(configuracaoDaPartida.value);
  }

  String? _validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) return 'Informe o nome do time';
    if (_timeA.text.trim() == _timeB.text.trim()) {
      return 'Os times precisam de nomes diferentes';
    }
    return null;
  }

  // Só guarda nomes válidos; com erro, a partida usa os últimos nomes válidos.
  void _salvarTimes() {
    if (!_times.currentState!.validate()) return;
    _mudar(
      (atual) => atual.copyWith(
        nomeTimeA: _timeA.text.trim(),
        nomeTimeB: _timeB.text.trim(),
      ),
    );
  }

  void _sair() {
    Navigator.popUntil(context, (rota) => rota.isFirst);
    widget.sair();
  }

  Widget _titulo(String texto) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(texto, style: Theme.of(context).textTheme.titleMedium),
  );

  Widget _numeros(
    String chave,
    List<int> opcoes,
    int atual,
    Configuracao Function(Configuracao config, int valor) mudanca,
  ) {
    return SegmentedButton<int>(
      key: ValueKey(chave),
      showSelectedIcon: false,
      segments: [
        for (final opcao in opcoes)
          ButtonSegment(value: opcao, label: Text('$opcao')),
      ],
      selected: {atual},
      onSelectionChanged: (escolha) =>
          _mudar((config) => mudanca(config, escolha.first)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ValueListenableBuilder(
        valueListenable: configuracaoDaPartida,
        builder: (context, config, _) => ListView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          children: [
            _titulo('Tema'),
            ValueListenableBuilder(
              valueListenable: modoDoTema,
              builder: (context, modo, _) => SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('Sistema'),
                  ),
                  ButtonSegment(value: ThemeMode.light, label: Text('Claro')),
                  ButtonSegment(value: ThemeMode.dark, label: Text('Escuro')),
                ],
                selected: {modo},
                onSelectionChanged: (escolha) =>
                    modoDoTema.value = escolha.first,
              ),
            ),
            _titulo('Baralho'),
            Column(
              spacing: 12,
              children: [
                for (final (i, baralho) in baralhos.indexed)
                  _OpcaoBaralho(
                    baralho: baralho,
                    icone: _aparencia[i].$1,
                    cor: _aparencia[i].$2,
                    escolhido: baralho == config.baralho,
                    aoEscolher: () =>
                        _mudar((atual) => atual.copyWith(baralho: baralho)),
                  ),
              ],
            ),
            _titulo('Times'),
            Form(
              key: _times,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                spacing: 12,
                children: [
                  TextFormField(
                    controller: _timeA,
                    decoration: const InputDecoration(labelText: 'Time 1'),
                    validator: _validarNome,
                    onChanged: (_) => _salvarTimes(),
                  ),
                  TextFormField(
                    controller: _timeB,
                    decoration: const InputDecoration(labelText: 'Time 2'),
                    validator: _validarNome,
                    onChanged: (_) => _salvarTimes(),
                  ),
                ],
              ),
            ),
            _titulo('Segundos por turno'),
            _numeros(
              'segundos',
              const [30, 60, 90],
              config.segundosPorTurno,
              (c, v) => c.copyWith(segundosPorTurno: v),
            ),
            _titulo('Rodadas'),
            _numeros(
              'rodadas',
              const [1, 2, 3, 4, 5],
              config.rodadas,
              (c, v) => c.copyWith(rodadas: v),
            ),
            _titulo('Pulos por turno'),
            _numeros(
              'pulos',
              const [0, 1, 2, 3],
              config.pulosPorTurno,
              (c, v) => c.copyWith(pulosPorTurno: v),
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: _sair,
              icon: const Icon(Icons.logout),
              label: const Text('Sair da conta'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpcaoBaralho extends StatelessWidget {
  const _OpcaoBaralho({
    required this.baralho,
    required this.icone,
    required this.cor,
    required this.escolhido,
    required this.aoEscolher,
  });

  final Baralho baralho;
  final IconData icone;
  final Color cor;
  final bool escolhido;
  final VoidCallback aoEscolher;

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Semantics(
      selected: escolhido,
      button: true,
      child: InkWell(
        onTap: aoEscolher,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(14),
          decoration:
              cartaoPop(
                context,
                borda: escolhido ? cores.primary : null,
              ).copyWith(
                color: escolhido ? cores.primary.withValues(alpha: 0.08) : null,
              ),
          child: Row(
            spacing: 14,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icone, color: tinta, size: 30),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      baralho.nome,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${baralho.cartas.length} cartas',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: cores.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (escolhido)
                CircleAvatar(
                  radius: 13,
                  backgroundColor: cores.primary,
                  child: Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: cores.onPrimary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
