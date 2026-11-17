import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/autenticacao.dart';

Future<bool> enviarComAviso(
  BuildContext context,
  Future<void> Function() acao, {
  String? sucesso,
}) async {
  String? mensagem = sucesso;
  var deuCerto = true;
  try {
    await acao();
  } on FirebaseAuthException catch (erro) {
    mensagem = mensagemDeErro(erro);
    deuCerto = false;
  } on Exception {
    mensagem = 'Não foi possível concluir. Tente de novo.';
    deuCerto = false;
  }
  if (mensagem != null && context.mounted) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }
  return deuCerto;
}
