import 'package:firebase_auth/firebase_auth.dart';

typedef Entrar = Future<void> Function(String email, String senha);
typedef Cadastrar = Future<void> Function(
  String nome,
  String email,
  String senha,
);

Future<void> entrarComFirebase(String email, String senha) => FirebaseAuth
    .instance
    .signInWithEmailAndPassword(email: email, password: senha);

Future<void> cadastrarComFirebase(
  String nome,
  String email,
  String senha,
) async {
  final credencial = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: senha,
  );
  await credencial.user?.updateDisplayName(nome);
}

String mensagemDeErro(FirebaseAuthException erro) => switch (erro.code) {
  'invalid-email' => 'Email inválido.',
  'invalid-credential' ||
  'invalid-login-credentials' => 'Email ou senha incorretos.',
  'email-already-in-use' => 'Já existe uma conta com este email.',
  'weak-password' => 'Senha fraca. Use pelo menos 6 caracteres.',
  'too-many-requests' => 'Muitas tentativas. Aguarde e tente de novo.',
  'network-request-failed' => 'Sem conexão. Verifique a internet.',
  'user-disabled' => 'Esta conta foi desativada.',
  _ => 'Não foi possível concluir. Tente de novo.',
};
