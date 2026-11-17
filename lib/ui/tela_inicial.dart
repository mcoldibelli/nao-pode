import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto/ui/tela_ajustes.dart';
import 'package:projeto/ui/tela_configuracao.dart';
import 'package:projeto/ui/tela_perfil.dart';
import 'package:projeto/ui/tela_tutorial.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  void _abrir(BuildContext context, Widget tela) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Não Pode'),
        actions: [
          IconButton(
            tooltip: 'Perfil',
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              final usuario = FirebaseAuth.instance.currentUser;
              _abrir(
                context,
                TelaPerfil(
                  nome: usuario?.displayName ?? '',
                  email: usuario?.email ?? '',
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Configurações',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _abrir(context, const TelaAjustes()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            const Text(
              'Faça seu time adivinhar a palavra sem falar as proibidas.',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () => _abrir(context, const TelaConfiguracao()),
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
