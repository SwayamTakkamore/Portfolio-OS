import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isInitialized = false;

  Future<void> playBootSound() async {
    try {
      // Set player mode for web compatibility
      if (!_isInitialized) {
        await _player.setPlayerMode(PlayerMode.mediaPlayer);
        _isInitialized = true;
      }

      await _player.setVolume(0.7);
      await _player.setReleaseMode(ReleaseMode.release);

      // Use assets path for web
      await _player.play(AssetSource('sounds/boot.mp3'),
          mode: PlayerMode.mediaPlayer);
    } catch (e) {
      print('Error playing boot sound: $e');
    }
  }

  void dispose() {
    _player.dispose();
  }
}
