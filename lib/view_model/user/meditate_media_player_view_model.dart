import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:safe_place_app/model/song_model.dart';

class UserMeditateMediaPlayerViewModel with ChangeNotifier {
  late SongModel song;
  late String label;
  AudioPlayer audioPlayer = AudioPlayer();

  void setAudioSources() {
    audioPlayer.setAudioSource(ConcatenatingAudioSource(
        children: [AudioSource.uri(Uri.parse(song.url))]));
    audioPlayer.play();
    audioPlayer.setLoopMode(LoopMode.one);
  }
}
