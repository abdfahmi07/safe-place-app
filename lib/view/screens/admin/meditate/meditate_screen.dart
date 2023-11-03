import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_place_app/view/screens/admin/meditate/meditate_add_screen.dart';

class AdminMeditateScreen extends StatefulWidget {
  const AdminMeditateScreen({super.key});

  @override
  State<AdminMeditateScreen> createState() => _AdminMeditateScreenState();
}

class _AdminMeditateScreenState extends State<AdminMeditateScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot<Object?>> songs = [];

  Future<void> getMeditateSongs() async {
    try {
      final QuerySnapshot tracksData = await _db
          .collection("Tracks")
          .orderBy("CreatedAt", descending: true)
          .get();

      setState(() {
        songs = tracksData.docs;
      });
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  void initState() {
    getMeditateSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 15),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('List Tracks',
                      style: GoogleFonts.playfairDisplay(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      )),
                  InkWell(
                    onTap: () {
                      Get.to(() => const AdminMeditateAddScreen());
                    },
                    child: const Row(children: [
                      Text(
                        'Add Track',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey)
                    ]),
                  )
                ]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  songs.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            return Container(
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
                                  width: 50,
                                  height: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      songs[index]["CoverUrl"],
                                      fit: BoxFit.cover,
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
                              ),
                            );
                          },
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(
                              child: Text(
                            'Nothing track anymore!',
                            style: TextStyle(color: Colors.grey),
                          )),
                        ),
                ],
              ),
            )
          ],
        ));
  }
}
