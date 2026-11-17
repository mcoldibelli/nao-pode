import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:projeto/ui/tela_ajustes.dart';
import 'package:projeto/ui/tela_perfil.dart';
import 'package:projeto/ui/tela_placar.dart';
import 'package:projeto/ui/tela_tutorial.dart';

import '../domain/partida.dart';
import 'estilo.dart';
import 'psiu.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key, this.nome = '', this.email = ''});

  final String nome;
  final String email;

  void _abrir(BuildContext context, Widget tela) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final saudacao = nome.trim().isEmpty ? '' : 'Oi, ${nome.trim()}! ';
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Row(
              children: [
                IconButton.outlined(
                  tooltip: 'Perfil',
                  onPressed: () =>
                      _abrir(context, TelaPerfil(nome: nome, email: email)),
                  icon: const Icon(Icons.person_rounded),
                ),
                const Spacer(),
                IconButton.outlined(
                  tooltip: 'Configurações',
                  onPressed: () => _abrir(context, const TelaAjustes()),
                  icon: const Icon(Icons.settings_rounded),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Center(child: Psiu(tamanho: 160))
                .animate()
                .scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: 12),
            Center(
              child: ValueListenableBuilder(
                valueListenable: configuracaoDaPartida,
                builder: (context, config, _) =>
                    Fala('${saudacao}Vamos de ${config.baralho.nome}?'),
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 300.ms),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _abrir(
                context,
                TelaPlacar(partida: Partida(configuracaoDaPartida.value)),
              ),
              child: const Text('Jogar'),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => _abrir(context, const TelaTutorial()),
              child: Text('Como jogar', style: TextStyle(color: cores.primary)),
            ),
          ],
        ),
      ),
    );
  }
}
