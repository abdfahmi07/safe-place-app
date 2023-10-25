import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButton extends StatelessWidget {
  const PlayerButton({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final PlayerState? playerState = snapshot.data;
              final ProcessingState processingState =
                  (playerState! as PlayerState).processingState;

              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  width: 64,
                  height: 64,
                  margin: const EdgeInsets.all(10),
                  child: const CircularProgressIndicator(),
                );
              } else if (!audioPlayer.playing) {
                return IconButton(
                    onPressed: audioPlayer.play,
                    iconSize: 72,
                    icon: const Icon(Icons.play_circle,
                        color: Color(0xFFEC9A4A)));
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                    onPressed: audioPlayer.pause,
                    iconSize: 72,
                    icon: const Icon(Icons.pause_circle,
                        color: Color(0xFFEC9A4A)));
              } else {
                return IconButton(
                    onPressed: () => audioPlayer.seek(Duration.zero,
                        index: audioPlayer.effectiveIndices!.first),
                    iconSize: 72,
                    icon: const Icon(Icons.replay_circle_filled_sharp,
                        color: Color(0xFFEC9A4A)));
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        )
      ],
    );
  }
}
