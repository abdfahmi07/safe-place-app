import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:safe_place_app/models/song_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_place_app/widgets/player_button.dart';
import 'package:safe_place_app/widgets/seekbar.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class MeditatePlayerScreen extends StatefulWidget {
  const MeditatePlayerScreen({super.key});

  @override
  State<MeditatePlayerScreen> createState() => _MeditatePlayerScreenState();
}

class _MeditatePlayerScreenState extends State<MeditatePlayerScreen> {
  Song song = Get.arguments;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    audioPlayer.setAudioSource(ConcatenatingAudioSource(
        children: [AudioSource.uri(Uri.parse('asset:///${song.url}'))]));
    audioPlayer.play();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          audioPlayer.positionStream, audioPlayer.durationStream,
          (Duration position, Duration? duration) {
        return SeekBarData(position, duration ?? Duration.zero);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Now Playing',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            _TrackPlayer(
                seekBarDataStream: _seekBarDataStream,
                audioPlayer: audioPlayer,
                song: song)
          ],
        ),
      ),
    );
  }
}

class _TrackPlayer extends StatelessWidget {
  const _TrackPlayer(
      {super.key,
      required Stream<SeekBarData> seekBarDataStream,
      required this.audioPlayer,
      required this.song})
      : _seekBarDataStream = seekBarDataStream;

  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 350,
          decoration: BoxDecoration(
              color: const Color(0xFFFFF3DD),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SvgPicture.asset(
              song.coverUrl,
              fit: BoxFit.contain,
              alignment: const Alignment(1, 0),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(song.title,
            style: GoogleFonts.playfairDisplay(
                fontSize: 20, fontWeight: FontWeight.w700)),
        Text(song.description,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF8597A2))),
        const SizedBox(height: 20),
        StreamBuilder<SeekBarData>(
          stream: _seekBarDataStream,
          builder: (context, snapshot) {
            final positionData = snapshot.data;
            return SeekBar(
                position: positionData?.position ?? Duration.zero,
                duration: positionData?.duration ?? Duration.zero,
                onChangeEnd: audioPlayer.seek);
          },
        ),
        PlayerButton(audioPlayer: audioPlayer)
      ],
    );
  }
}
