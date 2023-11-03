import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safe_place_app/model/song_model.dart';
import 'package:safe_place_app/view/screens/user/meditate/meditate_player_screen.dart';
import 'package:safe_place_app/view_model/user/meditate_view_model.dart';

class UserMeditateScreen extends StatefulWidget {
  const UserMeditateScreen({super.key});

  @override
  State<UserMeditateScreen> createState() => _MeditateScreenState();
}

class _MeditateScreenState extends State<UserMeditateScreen> {
  late UserMeditateViewModel userMeditateViewModel;

  @override
  void initState() {
    userMeditateViewModel =
        Provider.of<UserMeditateViewModel>(context, listen: false);
    userMeditateViewModel.getMeditateSongs();
    userMeditateViewModel.checkQuoteExp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF3DD),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Consumer<UserMeditateViewModel>(
                  builder: (context, value, _) {
                    if (value.quote.isNotEmpty) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(value.quote['quote'] ?? '',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(height: 10),
                            Text("- ${value.quote['author'] ?? ''}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w400)),
                          ]);
                    } else {
                      return const SizedBox(width: 10);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text('Select Categories',
                style: GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Consumer<UserMeditateViewModel>(
                builder: (context, value, _) {
                  final songs = value.songs;

                  if (songs.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => UserMeditatePlayerScreen(
                                    song: SongModel.fromSnapshot(songs[index]),
                                    label: 'meditate')));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 2, color: Colors.black12))),
                            child: ListTile(
                              leading: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFF3DD),
                                ),
                                width: 55,
                                height: 55,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    songs[index]["CoverUrl"],
                                    fit: BoxFit.cover,
                                    alignment: const Alignment(1.5, 0),
                                  ),
                                ),
                              ),
                              title: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(songs[index]["Title"],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500))),
                              subtitle: Text(
                                songs[index]["Description"],
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    // Get.toNamed('/meditate/track',
                                    //     arguments: [songs[index], 'meditate']);
                                  },
                                  icon: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF225560),
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: const Icon(Icons.play_arrow))),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox(width: 10);
                  }
                },
              ),
            )
          ],
        ));
  }
}
