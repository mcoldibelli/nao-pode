import 'package:flutter/material.dart';
import 'package:projeto/ui/tela_placar.dart';

import '../domain/baralho.dart';
import '../domain/configuracao.dart';
import '../domain/partida.dart';

class TelaConfiguracao extends StatefulWidget {
  const TelaConfiguracao({super.key, required this.baralho});

  final Baralho baralho;

  @override
  State<TelaConfiguracao> createState() => _TelaConfiguracaoState();
}

class _TelaConfiguracaoState extends State<TelaConfiguracao> {
  final _form = GlobalKey<FormState>();
  final _timeA = TextEditingController(text: 'Time A');
  final _timeB = TextEditingController(text: 'Time B');
  int _segundos = 60;
  int _rodadas = 3;
  int _pulos = 2;

  @override
  void dispose() {
    _timeA.dispose();
    _timeB.dispose();
    super.dispose();
  }

  String? _validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) return 'Informe o nome do time';
    if (_timeA.text.trim() == _timeB.text.trim()) {
      return 'Os times precisam de nomes diferentes';
    }
    return null;
  }

  void _comecar() {
    if (!_form.currentState!.validate()) return;
    final partida = Partida(
      Configuracao(
        nomeTimeA: _timeA.text.trim(),
        nomeTimeB: _timeB.text.trim(),
        baralho: widget.baralho,
        segundosPorTurno: _segundos,
        rodadas: _rodadas,
        pulosPorTurno: _pulos,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => TelaPlacar(partida: partida)),
    );
  }

  // TODO
  Widget _escolha(
    String rotulo,
    int valor,
    List<int> opcoes,
    ValueChanged<int> aoMudar,
  ) {
    return DropdownButtonFormField<int>(
      initialValue: valor,
      decoration: InputDecoration(labelText: rotulo),
      items: [
        for (final opcao in opcoes)
          DropdownMenuItem(value: opcao, child: Text('$opcao')),
      ],
      onChanged: (novo) => setState(() => aoMudar(novo!)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.baralho.nome)),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              TextFormField(
                controller: _timeA,
                decoration: const InputDecoration(labelText: 'Time 1'),
                validator: _validarNome,
              ),
              TextFormField(
                controller: _timeB,
                decoration: const InputDecoration(labelText: 'Time 2'),
                validator: _validarNome,
              ),
              _escolha('Segundos por turno', _segundos, [
                30,
                60,
                90,
              ], (v) => _segundos = v),
              _escolha('Rodadas', _rodadas, [
                1,
                2,
                3,
                4,
                5,
              ], (v) => _rodadas = v),
              _escolha('Pulos por turno', _pulos, [
                0,
                1,
                2,
                3,
              ], (v) => _pulos = v),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _comecar, child: const Text('Começar')),
            ],
          ),
        ),
      ),
    );
  }
}
