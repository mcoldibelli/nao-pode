import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/autenticacao.dart';
import 'envio.dart';
import 'estilo.dart';
import 'psiu.dart';
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
    await enviarComAviso(
      context,
      () => widget.entrar(_email.text.trim(), _senha.text),
    );
    // Depois de entrar, main.dart troca esta tela pela inicial.
    if (mounted) setState(() => _enviando = false);
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 12,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Psiu(tamanho: 120)
                        .animate()
                        .scale(duration: 400.ms, curve: Curves.elasticOut),
                    const Flexible(child: Fala('Psiu! Entra aí.')),
                  ],
                ),
                Text(
                  'não pode',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall
                      ?.copyWith(color: cores.primary),
                ),
                Text(
                  'Faça seu time adivinhar.\nSem falar as proibidas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: cores.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
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
                  validator: (valor) => (valor == null || valor.isEmpty)
                      ? 'Informe a senha'
                      : null,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _enviando ? null : _entrar,
                  child: Text(_enviando ? 'Entrando...' : 'Entrar'),
                ),
                OutlinedButton(
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
      ),
    );
  }
}
