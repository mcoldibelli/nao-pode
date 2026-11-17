import 'dart:math';

import 'package:flutter/material.dart';

const framboesa = Color(0xFFD61C57);
const framboesaBase = Color(0xFFA3123F);
const turquesa = Color(0xFF19C3B1);
const turquesaBase = Color(0xFF0E9485);
const turquesaTexto = Color(0xFF10302D);
const turquesaClaro = Color(0xFFDDF7F3);
const turquesaEscuro = Color(0xFF0B6B61);
const sol = Color(0xFFFFB938);
const rosa = Color(0xFFFF8FB1);
const rosaClaro = Color(0xFFFFE3EA);
const tinta = Color(0xFF3C2A35);

/// Botão "de apertar": cor cheia com base 4px mais escura que afunda ao tocar.
ButtonStyle estiloPop({
  required Color cor,
  required Color base,
  required Color texto,
  Color? borda,
}) {
  return ButtonStyle(
    foregroundColor: WidgetStatePropertyAll(texto),
    // A cor fica no backgroundBuilder; o fundo padrão apareceria atrás.
    backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
    shadowColor: const WidgetStatePropertyAll(Colors.transparent),
    minimumSize: const WidgetStatePropertyAll(Size(64, 56)),
    elevation: const WidgetStatePropertyAll(0),
    padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 20)),
    shape: const WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    textStyle: const WidgetStatePropertyAll(
      TextStyle(
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w900,
        fontSize: 17,
      ),
    ),
    backgroundBuilder: (context, estados, child) {
      final apertado = estados.contains(WidgetState.pressed);
      final ativo = !estados.contains(WidgetState.disabled);
      // Duas camadas: a base escura atrás e a face 4px acima dela.
      // (Border com cores diferentes por lado não aceita cantos redondos.)
      final opaco = ativo ? 1.0 : 0.45;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        margin: EdgeInsets.only(top: apertado ? 4 : 0),
        padding: EdgeInsets.only(bottom: apertado ? 0 : 4),
        decoration: BoxDecoration(
          color: base.withValues(alpha: opaco),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: cor.withValues(alpha: opaco),
            borderRadius: BorderRadius.circular(16),
            border: borda == null ? null : Border.all(color: borda, width: 2),
          ),
          child: child,
        ),
      );
    },
  );
}

ThemeData temaDoApp(Brightness brilho) {
  final escuro = brilho == Brightness.dark;
  final fundo = escuro ? const Color(0xFF1F1720) : Colors.white;
  final texto = escuro ? const Color(0xFFF5ECF0) : tinta;
  final linha = escuro ? const Color(0xFF45353F) : const Color(0xFFECE3E7);
  final campo = escuro ? const Color(0xFF2A2029) : const Color(0xFFF8F4F6);
  final cores =
      ColorScheme.fromSeed(
        seedColor: framboesa,
        brightness: brilho,
        dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
      ).copyWith(
        primary: escuro ? const Color(0xFFFF7AA3) : framboesa,
        secondary: turquesa,
        onSecondary: turquesaTexto,
        tertiary: sol,
        surface: fundo,
        onSurface: texto,
        outlineVariant: linha,
      );
  const fredoka = TextStyle(fontFamily: 'Fredoka', fontWeight: FontWeight.w700);
  final base = ThemeData(colorScheme: cores, fontFamily: 'Nunito');
  return base.copyWith(
    scaffoldBackgroundColor: fundo,
    textTheme: base.textTheme
        .copyWith(
          displaySmall: fredoka,
          headlineLarge: fredoka,
          headlineMedium: fredoka,
          headlineSmall: fredoka,
          titleLarge: fredoka.copyWith(fontWeight: FontWeight.w600),
        )
        .apply(bodyColor: texto, displayColor: texto),
    appBarTheme: AppBarTheme(
      backgroundColor: fundo,
      foregroundColor: texto,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: fredoka.copyWith(fontSize: 22, color: texto),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: campo,
      labelStyle: const TextStyle(fontWeight: FontWeight.w800),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: linha, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: linha, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: cores.primary, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: estiloPop(
        cor: framboesa,
        base: framboesaBase,
        texto: Colors.white,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: estiloPop(
        cor: fundo,
        base: linha,
        texto: cores.primary,
        borda: linha,
      ).copyWith(side: const WidgetStatePropertyAll(BorderSide.none)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: cores.primary,
        minimumSize: const Size(48, 48),
        textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}

/// Cartão com borda 2px e base mais grossa, o mesmo do botão.
BoxDecoration cartaoPop(BuildContext context, {Color? borda, double base = 4}) {
  final cor = borda ?? Theme.of(context).colorScheme.outlineVariant;
  return BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(20),
    border: Border(
      top: BorderSide(color: cor, width: 2),
      left: BorderSide(color: cor, width: 2),
      right: BorderSide(color: cor, width: 2),
      bottom: BorderSide(color: cor, width: base),
    ),
  );
}

/// Balão de fala ao lado do mascote.
class Fala extends StatelessWidget {
  const Fala(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: cartaoPop(context, base: 2),
      child: Text(
        texto,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
      ),
    );
  }
}

/// Psiu, o mascote: o balão do ícone com boca de zíper.
/// O zíper abre quando [feliz] é verdadeiro.
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
