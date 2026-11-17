import 'dart:math';

import 'package:flutter/material.dart';

import 'estilo.dart';

class Psiu extends StatelessWidget {
  const Psiu({super.key, this.feliz = false, this.tamanho = 120});

  final bool feliz;
  final double tamanho;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: feliz ? 'Psiu comemorando' : 'Psiu, o mascote',
      child: CustomPaint(
        size: Size.square(tamanho),
        painter: _PintorPsiu(feliz),
      ),
    );
  }
}

class _PintorPsiu extends CustomPainter {
  _PintorPsiu(this.feliz);

  final bool feliz;

  @override
  void paint(Canvas canvas, Size size) {
    // Desenhado num quadro de 120 x 120, igual ao SVG do conceito.
    canvas.scale(size.width / 120);
    final cheio = Paint();
    final traco = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = tinta;
    final sobe = feliz ? -6.0 : 0.0;

    cheio.color = tinta.withValues(alpha: 0.1);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(62, 113), width: 68, height: 10),
      cheio,
    );

    void corpo(double y, Color cor) {
      cheio.color = cor;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(14, y, 92, 80),
          const Radius.circular(38),
        ),
        cheio,
      );
      canvas.drawPath(
        Path()
          ..moveTo(30, y + 66)
          ..lineTo(22, y + 90)
          ..lineTo(52, y + 74)
          ..close(),
        cheio,
      );
    }

    corpo(20 + sobe, framboesaBase);
    corpo(14 + sobe, framboesa);

    canvas.save();
    canvas.translate(38, 30 + sobe);
    canvas.rotate(-25 * pi / 180);
    cheio.color = Colors.white.withValues(alpha: 0.3);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 22, height: 12),
      cheio,
    );
    canvas.restore();

    cheio.color = rosa;
    final bochechaY = feliz ? 58.0 : 64.0;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(32, bochechaY), width: 14, height: 8),
      cheio,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(88, bochechaY), width: 14, height: 8),
      cheio,
    );

    if (feliz) {
      traco.strokeWidth = 5;
      canvas.drawPath(
        Path()
          ..moveTo(36, 44)
          ..quadraticBezierTo(46, 32, 56, 44),
        traco,
      );
      canvas.drawPath(
        Path()
          ..moveTo(64, 44)
          ..quadraticBezierTo(74, 32, 84, 44),
        traco,
      );
      cheio.color = tinta;
      canvas.drawPath(
        Path()
          ..moveTo(42, 60)
          ..lineTo(78, 60)
          ..quadraticBezierTo(78, 78, 60, 78)
          ..quadraticBezierTo(42, 78, 42, 60)
          ..close(),
        cheio,
      );
      cheio.color = rosa;
      canvas.drawPath(
        Path()
          ..moveTo(50, 70)
          ..quadraticBezierTo(60, 78, 70, 70)
          ..quadraticBezierTo(66, 78, 60, 78)
          ..quadraticBezierTo(54, 78, 50, 70)
          ..close(),
        cheio,
      );
      _puxador(canvas, const Offset(82, 61), 25);
      return;
    }

    cheio.color = Colors.white;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(46, 46), width: 22, height: 26),
      cheio,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(74, 46), width: 22, height: 26),
      cheio,
    );
    cheio.color = tinta;
    canvas.drawCircle(const Offset(48, 49), 6.5, cheio);
    canvas.drawCircle(const Offset(76, 49), 6.5, cheio);
    cheio.color = Colors.white;
    canvas.drawCircle(const Offset(50, 46), 2.2, cheio);
    canvas.drawCircle(const Offset(78, 46), 2.2, cheio);

    traco.strokeWidth = 4;
    canvas.drawLine(const Offset(44, 72), const Offset(76, 72), traco);
    traco.strokeWidth = 2.4;
    for (final x in [49.0, 55.0, 61.0, 67.0]) {
      canvas.drawLine(Offset(x, 68), Offset(x, 76), traco);
    }
    _puxador(canvas, const Offset(79, 73), 0);
  }

  void _puxador(Canvas canvas, Offset centro, double graus) {
    canvas.save();
    canvas.translate(centro.dx, centro.dy);
    canvas.rotate(graus * pi / 180);
    final forma = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: 8, height: 10),
      const Radius.circular(2.5),
    );
    canvas.drawRRect(forma, Paint()..color = sol);
    canvas.drawRRect(
      forma,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..color = tinta,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_PintorPsiu antigo) => antigo.feliz != feliz;
}
