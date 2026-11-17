import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/autenticacao.dart';
import 'tela_cadastro.dart';

String? validarEmail(String? valor) {
  final email = valor?.trim() ?? '';
  if (email.isEmpty) return 'Informe o email';
  if (!email.contains('@')) return 'Email inválido';
  return null;
}

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key, this.entrar = entrarComFirebase});

  final Entrar entrar;

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  bool _enviando = false;

  @override
  void dispose() {
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _enviando = true);
    try {
      await widget.entrar(_email.text.trim(), _senha.text);
    } on FirebaseAuthException catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensagemDeErro(erro))));
    } finally {
      // Depois de entrar, main.dart troca esta tela pela inicial.
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Não Pode')),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: validarEmail,
              ),
              TextFormField(
                controller: _senha,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                validator: (valor) =>
                    (valor == null || valor.isEmpty) ? 'Informe a senha' : null,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _enviando ? null : _entrar,
                child: Text(_enviando ? 'Entrando...' : 'Entrar'),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TelaCadastro()),
                ),
                child: const Text('Criar conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
