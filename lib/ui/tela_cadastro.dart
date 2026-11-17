import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/autenticacao.dart';
import 'tela_login.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key, this.cadastrar = cadastrarComFirebase});

  final Cadastrar cadastrar;

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _form = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();
  final _confirmacao = TextEditingController();
  bool _enviando = false;

  @override
  void dispose() {
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    _confirmacao.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _enviando = true);
    try {
      await widget.cadastrar(
        _nome.text.trim(),
        _email.text.trim(),
        _senha.text,
      );
      // A conta já está logada: ao fechar esta tela, aparece a tela inicial.
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensagemDeErro(erro))));
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              TextFormField(
                controller: _nome,
                decoration: const InputDecoration(labelText: 'Nome'),
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.name],
                validator: (valor) => (valor == null || valor.trim().isEmpty)
                    ? 'Informe o nome'
                    : null,
              ),
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
                autofillHints: const [AutofillHints.newPassword],
                validator: (valor) => (valor == null || valor.length < 6)
                    ? 'A senha precisa de pelo menos 6 caracteres'
                    : null,
              ),
              TextFormField(
                controller: _confirmacao,
                decoration: const InputDecoration(labelText: 'Confirmar senha'),
                obscureText: true,
                validator: (valor) =>
                    valor != _senha.text ? 'As senhas não conferem' : null,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _enviando ? null : _cadastrar,
                child: Text(_enviando ? 'Criando...' : 'Criar conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
