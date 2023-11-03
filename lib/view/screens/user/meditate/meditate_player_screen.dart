import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_place_app/model/song_model.dart';
import 'package:safe_place_app/view/layouts/user/user_bottom_navbar_layout.dart';
import 'package:safe_place_app/view/widget/player_button_widget.dart';
import 'package:safe_place_app/view/widget/seekbar_widget.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:safe_place_app/view_model/user/meditate_media_player_view_model.dart';

class UserMeditatePlayerScreen extends StatefulWidget {
  const UserMeditatePlayerScreen(
      {super.key, required this.song, required this.label});

  final SongModel song;
  final String label;

  @override
  State<UserMeditatePlayerScreen> createState() => _MeditatePlayerScreenState();
}

class _MeditatePlayerScreenState extends State<UserMeditatePlayerScreen> {
  late UserMeditateMediaPlayerViewModel userMeditateMediaPlayerViewModel;

  Future<bool> _onBackPressed() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => UserBottomNavbarLayout(
                  page: userMeditateMediaPlayerViewModel.label == 'meditate'
                      ? 1
                      : 2,
                  appBarTitle:
                      userMeditateMediaPlayerViewModel.label == 'meditate'
                          ? 'Meditate'
                          : 'Favorite',
                )),
        (route) => false);

    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();
    userMeditateMediaPlayerViewModel =
        Provider.of<UserMeditateMediaPlayerViewModel>(context, listen: false);
    userMeditateMediaPlayerViewModel.label = widget.label;
    userMeditateMediaPlayerViewModel.song = widget.song;
    userMeditateMediaPlayerViewModel.setAudioSources();
  }

  @override
  void dispose() {
    userMeditateMediaPlayerViewModel.audioPlayer.dispose();
    super.dispose();
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          userMeditateMediaPlayerViewModel.audioPlayer.positionStream,
          userMeditateMediaPlayerViewModel.audioPlayer.durationStream,
          (Duration position, Duration? duration) {
        return SeekBarData(position, duration ?? Duration.zero);
      });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
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
                  audioPlayer: userMeditateMediaPlayerViewModel.audioPlayer,
                  song: userMeditateMediaPlayerViewModel.song)
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackPlayer extends StatelessWidget {
  const _TrackPlayer(
      {required Stream<SeekBarData> seekBarDataStream,
      required this.audioPlayer,
      required this.song})
      : _seekBarDataStream = seekBarDataStream;

  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;
  final SongModel song;

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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                song.coverUrl,
                fit: BoxFit.cover,
              ),
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
        PlayerButton(audioPlayer: audioPlayer, song: song),
      ],
    );
  }
}
