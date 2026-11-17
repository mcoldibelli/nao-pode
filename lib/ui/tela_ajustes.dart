import 'package:flutter/material.dart';

import '../data/autenticacao.dart';
import '../data/baralhos.dart';
import '../domain/baralho.dart';
import 'estilo.dart';

final modoDoTema = ValueNotifier(ThemeMode.system);
final baralhoEscolhido = ValueNotifier<Baralho>(baralhos.first);

// Ícone e cor de cada baralho, na ordem de data/baralhos.dart.
const _aparencia = [
  (Icons.eco_rounded, turquesa),
  (Icons.favorite_rounded, rosa),
  (Icons.groups_rounded, sol),
];

class TelaAjustes extends StatelessWidget {
  const TelaAjustes({super.key, this.sair = sairDoFirebase});

  final Sair sair;

  void _sair(BuildContext context) {
    Navigator.popUntil(context, (rota) => rota.isFirst);
    sair();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Tema', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: modoDoTema,
            builder: (context, modo, _) => SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, label: Text('Sistema')),
                ButtonSegment(value: ThemeMode.light, label: Text('Claro')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Escuro')),
              ],
              selected: {modo},
              onSelectionChanged: (escolha) => modoDoTema.value = escolha.first,
            ),
          ),
          const SizedBox(height: 24),
          Text('Baralho', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ValueListenableBuilder(
            valueListenable: baralhoEscolhido,
            builder: (context, escolhido, _) => Column(
              spacing: 12,
              children: [
                for (final (i, baralho) in baralhos.indexed)
                  _OpcaoBaralho(
                    baralho: baralho,
                    icone: _aparencia[i].$1,
                    cor: _aparencia[i].$2,
                    escolhido: baralho == escolhido,
                    aoEscolher: () => baralhoEscolhido.value = baralho,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () => _sair(context),
            icon: const Icon(Icons.logout),
            label: const Text('Sair da conta'),
          ),
        ],
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
