import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:projeto/ui/tela_ajustes.dart';
import 'package:projeto/ui/tela_configuracao.dart';
import 'package:projeto/ui/tela_perfil.dart';
import 'package:projeto/ui/tela_tutorial.dart';

import '../data/baralhos.dart';
import '../domain/baralho.dart';
import 'estilo.dart';
import 'psiu.dart';

// Ícone e cor de cada baralho, na ordem de data/baralhos.dart.
const _aparencia = [
  (Icons.eco_rounded, turquesa),
  (Icons.favorite_rounded, rosa),
  (Icons.groups_rounded, sol),
];

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key, this.nome = '', this.email = ''});

  final String nome;
  final String email;

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  Baralho _baralho = baralhos.first;

  void _abrir(Widget tela) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
  }

  void _abrirPerfil() {
    _abrir(TelaPerfil(nome: widget.nome, email: widget.email));
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final nome = widget.nome.trim();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Row(
              children: [
                IconButton.outlined(
                  tooltip: 'Perfil',
                  onPressed: _abrirPerfil,
                  icon: const Icon(Icons.person_rounded),
                ),
                const Spacer(),
                IconButton.outlined(
                  tooltip: 'Configurações',
                  onPressed: () => _abrir(const TelaAjustes()),
                  icon: const Icon(Icons.settings_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              spacing: 8,
              children: [
                const Psiu(tamanho: 92),
                Flexible(
                  child: Fala(
                    nome.isEmpty
                        ? 'Qual baralho vai ser hoje?'
                        : 'Oi, $nome! Qual baralho vai ser hoje?',
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.05),
            const SizedBox(height: 16),
            for (final (i, baralho) in baralhos.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child:
                    _OpcaoBaralho(
                          baralho: baralho,
                          icone: _aparencia[i].$1,
                          cor: _aparencia[i].$2,
                          escolhido: baralho == _baralho,
                          aoEscolher: () => setState(() => _baralho = baralho),
                        )
                        .animate(delay: (80 * i).ms)
                        .fadeIn(duration: 250.ms)
                        .slideY(begin: 0.2, curve: Curves.easeOutBack),
              ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _abrir(TelaConfiguracao(baralho: _baralho)),
              child: const Text('Jogar'),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => _abrir(const TelaTutorial()),
              child: Text('Como jogar', style: TextStyle(color: cores.primary)),
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
