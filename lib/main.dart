import 'package:flutter/material.dart';
import 'package:projeto/ui/tela_inicial.dart';

import 'domain/loja.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Não Pode",
      home: TelaInicial(loja: Loja()),
    ),
  );
}
