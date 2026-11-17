import 'dart:math';

import 'package:flutter/material.dart';

import '../domain/resultado.dart';
import 'estilo.dart';
import 'resultado_na_tela.dart';

/// Carta que se arrasta: direita = acertou, esquerda = errou,
/// cima ou baixo = pulou. Passou do limite (ou foi jogada rápido):
/// a carta sai voando e [aoSoltar] recebe o resultado.
class CartaArrastavel extends StatefulWidget {
  const CartaArrastavel({
    super.key,
    required this.podePular,
    required this.aoSoltar,
    required this.child,
  });

  final bool podePular;
  final ValueChanged<Resultado> aoSoltar;
  final Widget child;

  @override
  State<CartaArrastavel> createState() => _CartaArrastavelState();
}

class _CartaArrastavelState extends State<CartaArrastavel>
    with SingleTickerProviderStateMixin {
  static const _limite = 100.0;

  late final _movimento = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );
  Offset _arraste = Offset.zero;
  bool _saindo = false;

  @override
  void dispose() {
    _movimento.dispose();
    super.dispose();
  }

  Resultado? _resultado(Offset deslocamento) {
    final horizontal = deslocamento.dx.abs() >= deslocamento.dy.abs();
    if (horizontal && deslocamento.dx > _limite) return Resultado.acertou;
    if (horizontal && deslocamento.dx < -_limite) return Resultado.errou;
    if (!horizontal && deslocamento.dy.abs() > _limite && widget.podePular) {
      return Resultado.pulou;
    }
    return null;
  }

  void _animarAte(Offset alvo, Curve curva, VoidCallback aoTerminar) {
    final caminho = Tween(
      begin: _arraste,
      end: alvo,
    ).chain(CurveTween(curve: curva)).animate(_movimento);
    void mover() => setState(() => _arraste = caminho.value);
    _movimento
      ..addListener(mover)
      ..forward(from: 0).whenComplete(() {
        _movimento.removeListener(mover);
        aoTerminar();
      });
  }

  void _soltar(DragEndDetails detalhes) {
    // A velocidade conta: um "peteleco" rápido também vale.
    final projetado = _arraste + detalhes.velocity.pixelsPerSecond * 0.15;
    final resultado = _resultado(projetado);
    if (resultado == null) {
      _animarAte(Offset.zero, Curves.easeOutBack, () {});
      return;
    }
    _saindo = true;
    final tela = MediaQuery.sizeOf(context);
    final alvo = switch (resultado) {
      Resultado.acertou => Offset(tela.width * 1.5, _arraste.dy),
      Resultado.errou => Offset(-tela.width * 1.5, _arraste.dy),
      Resultado.pulou => Offset(
        _arraste.dx,
        tela.height * (_arraste.dy < 0 ? -1 : 1),
      ),
    };
    _animarAte(alvo, Curves.easeIn, () => widget.aoSoltar(resultado));
  }

  @override
  Widget build(BuildContext context) {
    final resultado = _intencao();
    final forca = (max(_arraste.dx.abs(), _arraste.dy.abs()) / _limite).clamp(
      0.0,
      1.0,
    );
    return GestureDetector(
      onPanUpdate: _saindo
          ? null
          : (detalhes) => setState(() => _arraste += detalhes.delta),
      onPanEnd: _saindo ? null : _soltar,
      child: Transform.translate(
        offset: _arraste,
        child: Transform.rotate(
          angle: _arraste.dx / 900,
          child: Stack(
            children: [
              Positioned.fill(child: widget.child),
              if (resultado != null)
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Opacity(opacity: forca, child: _Carimbo(resultado)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Para onde o dedo aponta, antes de passar do limite.
  Resultado? _intencao() {
    if (_arraste == Offset.zero) return null;
    if (_arraste.dx.abs() >= _arraste.dy.abs()) {
      return _arraste.dx > 0 ? Resultado.acertou : Resultado.errou;
    }
    return widget.podePular ? Resultado.pulou : null;
  }
}

class _Carimbo extends StatelessWidget {
  const _Carimbo(this.resultado);

  final Resultado resultado;

  @override
  Widget build(BuildContext context) {
    final (fundo, texto) = switch (resultado) {
      Resultado.acertou => (turquesa, turquesaTexto),
      Resultado.errou => (rosaClaro, framboesaBase),
      Resultado.pulou => (sol, tinta),
    };
    return Transform.rotate(
      angle: -0.12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: fundo,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: texto, width: 3),
        ),
        child: Text(
          resultado.rotulo.toUpperCase(),
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontWeight: FontWeight.w700,
            fontSize: 24,
            letterSpacing: 1,
            color: texto,
          ),
        ),
      ),
    );
  }
}
