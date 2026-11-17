import 'package:audioplayers/audioplayers.dart';

final _tocadores = <String, AudioPlayer>{};

void Function(String som) tocarSom = (som) {
  final tocador = _tocadores.putIfAbsent(
    som,
    () => AudioPlayer()..setPlayerMode(PlayerMode.lowLatency),
  );
  tocador.play(AssetSource('sons/$som.wav'));
};
