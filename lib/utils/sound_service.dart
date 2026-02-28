import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playMove() async {
    await _player.play(AssetSource('move.mp3'));
  }
}