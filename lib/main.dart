import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projeto/ui/estilo.dart';
import 'package:projeto/ui/tela_ajustes.dart';
import 'package:projeto/ui/tela_inicial.dart';
import 'package:projeto/ui/tela_login.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ValueListenableBuilder(
      valueListenable: modoDoTema,
      builder: (context, modo, _) => MaterialApp(
        title: "Não Pode",
        themeMode: modo,
        theme: temaDoApp(Brightness.light),
        darkTheme: temaDoApp(Brightness.dark),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, sessao) {
            if (sessao.connectionState == ConnectionState.waiting) {
              return const Scaffold();
            }
            final usuario = sessao.data;
            if (usuario == null) return const TelaLogin();
            return TelaInicial(nome: usuario.displayName ?? '');
          },
        ),
      ),
    ),
  );
}
