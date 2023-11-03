import 'dart:async';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:safe_place_app/model/song_model.dart';

class PlayerButton extends StatefulWidget {
  const PlayerButton(
      {super.key, required this.audioPlayer, required this.song});

  final AudioPlayer audioPlayer;
  final SongModel song;

  @override
  State<PlayerButton> createState() => _PlayerButtonState();
}

class _PlayerButtonState extends State<PlayerButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TimerButton(audioPlayer: widget.audioPlayer),
        StreamBuilder<PlayerState>(
          stream: widget.audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final PlayerState? playerState = snapshot.data;
              final ProcessingState processingState =
                  (playerState! as PlayerState).processingState;

              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  width: 55,
                  height: 55,
                  margin: const EdgeInsets.all(16),
                  child: const CircularProgressIndicator(),
                );
              } else if (!widget.audioPlayer.playing) {
                return IconButton(
                    onPressed: widget.audioPlayer.play,
                    iconSize: 72,
                    icon: const Icon(Icons.play_circle_fill_rounded,
                        color: Color(0xFFEC9A4A)));
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                    onPressed: widget.audioPlayer.pause,
                    iconSize: 72,
                    icon: const Icon(Icons.pause_circle_filled_rounded,
                        color: Color(0xFFEC9A4A)));
              } else {
                return IconButton(
                    onPressed: () => widget.audioPlayer.seek(Duration.zero,
                        index: widget.audioPlayer.effectiveIndices!.first),
                    iconSize: 72,
                    icon: const Icon(Icons.replay_circle_filled_rounded,
                        color: Color(0xFFEC9A4A)));
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        FavoriteButton(song: widget.song),
      ],
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.song});

  final SongModel song;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late bool isFavorited;

  Future<void> addTrackToFavorite() async {
    setState(() {
      isFavorited = !isFavorited;
    });

    try {
      final trackRef = _db.collection("Tracks").doc("${widget.song.id}");
      debugPrint('=> $trackRef $isFavorited');
      await trackRef.update({"IsFavorited": isFavorited});

      if (isFavorited) {
        debugPrint('=> true');
        await createNewFavoriteTracks();
      } else {
        debugPrint('=> false');
        await deleteFromFavoriteTracks();
      }
    } catch (err) {
      debugPrint("Error updating document $err");
    }
  }

  Future<void> createNewFavoriteTracks() async {
    try {
      final SongModel song = SongModel(
          title: widget.song.title,
          description: widget.song.description,
          url: widget.song.url,
          coverUrl: widget.song.coverUrl,
          createdAt: widget.song.createdAt,
          isFavorited: isFavorited);

      await _db
          .collection("Favorite Tracks")
          .doc("${widget.song.id}")
          .set(song.toJson());
    } catch (err) {
      debugPrint('=> $err');
    }
  }

  Future<void> deleteFromFavoriteTracks() async {
    try {
      _db.collection("Favorite Tracks").doc("${widget.song.id}").delete();
    } catch (err) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();

    isFavorited = widget.song.isFavorited;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('=> $isFavorited');
    return IconButton(
        onPressed: addTrackToFavorite,
        iconSize: 30,
        icon: isFavorited
            ? const Icon(
                Iconsax.heart5,
                color: Color(0xFFF8BAB4),
              )
            : const Icon(Iconsax.heart, color: Colors.black));
  }
}

class TimerButton extends StatefulWidget {
  const TimerButton({super.key, required this.audioPlayer});

  final AudioPlayer audioPlayer;

  @override
  State<TimerButton> createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  List<int> minutes = [3, 5, 15, 30, 45, 60];
  int? countdownDuration;
  Duration duration = const Duration();
  Timer? timer;

  void addTime() {
    debugPrint('=> $duration');
    setState(() {
      final seconds = duration.inSeconds + (-1);

      if (seconds < 0) {
        timer?.cancel();
        widget.audioPlayer.stop();
        countdownDuration = null;
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void resetTimer(int minutes) {
    setState(() {
      countdownDuration = minutes;
      duration = Duration(minutes: minutes);
    });
  }

  void _openSimpleItemPicker(BuildContext context) {
    BottomPicker(
      titlePadding: const EdgeInsets.symmetric(vertical: 15),
      items: const [
        Text('3 Minute',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, height: 1.8)),
        Text('5 Minute',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, height: 1.8)),
        Text('15 Minute',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, height: 1.8)),
        Text('30 Minute',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, height: 1.8)),
        Text('45 Minute',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, height: 1.8)),
        Text('60 Minute',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, height: 1.8)),
      ],
      title: 'Choose Timer',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      backgroundColor: Colors.white,
      bottomPickerTheme: BottomPickerTheme.plumPlate,
      onSubmit: (index) {
        if (countdownDuration == null) {
          startTimer();
          resetTimer(minutes[index]);
        } else {
          resetTimer(minutes[index]);
        }
      },
      buttonAlignment: MainAxisAlignment.center,
      buttonSingleColor: const Color(0xFFEC9A4A),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      IconButton(
          onPressed: () {
            _openSimpleItemPicker(context);
          },
          iconSize: 30,
          icon: const Icon(
            Iconsax.clock,
            color: Colors.black,
          )),
      countdownDuration != null
          ? Positioned(
              right: 0,
              top: 0,
              child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: const Color(0xFFEC9B4A),
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: Text(
                      '$countdownDuration',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  )))
          : const SizedBox(),
    ]);
  }
}
