import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_place_app/models/song_model.dart';

class MeditateScreen extends StatefulWidget {
  const MeditateScreen({super.key});

  @override
  State<MeditateScreen> createState() => _MeditateScreenState();
}

class _MeditateScreenState extends State<MeditateScreen> {
  Map<String, dynamic> quote = {};
  final dioInit = dio.Dio();

  void getQuote() async {
    try {
      final dio.Response response =
          await dioInit.get('https://api.api-ninjas.com/v1/quotes',
              options: dio.Options(headers: {
                'X-Api-Key': 't0uNkYR9cvfGeKam9CRW3A==sjfOFrL7bdoLJ2gJ',
              }),
              queryParameters: {'category': 'happiness'});
      final Map<String, dynamic> responseData = response.data[0];
      debugPrint('=> ${responseData.toString()}');
      setState(() {
        quote = responseData;
      });
    } catch (err) {
      debugPrint('=> ${err.toString()}');
    }
  }

  @override
  void initState() {
    getQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Song> songs = Song.songs;

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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(quote['quote'] ?? '',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400)),
                      const SizedBox(height: 10),
                      Text("- ${quote['author'] ?? ''}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w400)),
                    ]),
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
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.toNamed('/meditate/track', arguments: songs[index]);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 2, color: Colors.black12))),
                      child: ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFFFF3DD),
                              borderRadius: BorderRadius.circular(10)),
                          width: 50,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: SvgPicture.asset(
                              songs[index].coverUrl,
                              fit: BoxFit.cover,
                              alignment: const Alignment(1.5, 0),
                            ),
                          ),
                        ),
                        title: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(songs[index].title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500))),
                        subtitle: Text(
                          songs[index].description,
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              Get.toNamed('/meditate/track',
                                  arguments: songs[index]);
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
              ),
            )
          ],
        ));
  }
}
