import 'package:flutter/material.dart';
import 'package:projeto/ui/tela_inicial.dart';

import 'domain/loja.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Não Pode",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE5245E),
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE5245E),
          brightness: Brightness.dark,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ),
      ),
      home: TelaInicial(loja: Loja()),
    ),
  );
}
