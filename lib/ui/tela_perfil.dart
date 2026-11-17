import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/autenticacao.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({
    super.key,
    required this.nome,
    required this.email,
    this.salvarNome = salvarNomeNoFirebase,
  });

  final String nome;
  final String email;
  final SalvarNome salvarNome;

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final _form = GlobalKey<FormState>();
  late final _nome = TextEditingController(text: widget.nome);
  bool _enviando = false;

  @override
  void dispose() {
    _nome.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _enviando = true);
    String mensagem;
    try {
      await widget.salvarNome(_nome.text.trim());
      mensagem = 'Nome atualizado.';
    } on FirebaseAuthException catch (erro) {
      mensagem = mensagemDeErro(erro);
    }
    if (!mounted) return;
    setState(() => _enviando = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
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
                validator: (valor) => (valor == null || valor.trim().isEmpty)
                    ? 'Informe o nome'
                    : null,
              ),
              TextFormField(
                initialValue: widget.email,
                decoration: const InputDecoration(labelText: 'Email'),
                readOnly: true,
                enabled: false,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _enviando ? null : _salvar,
                child: Text(_enviando ? 'Salvando...' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
