import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserFavoriteMeditateScreen extends StatefulWidget {
  const UserFavoriteMeditateScreen({super.key});

  @override
  State<UserFavoriteMeditateScreen> createState() =>
      _FavoriteMeditateScreenState();
}

class _FavoriteMeditateScreenState extends State<UserFavoriteMeditateScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot<Object?>> favoriteSongs = [];

  Future<void> getFavoriteMeditateSongs() async {
    try {
      final QuerySnapshot favoriteTracksData = await _db
          .collection("Favorite Tracks")
          .orderBy('CreatedAt', descending: true)
          .get();

      setState(() {
        favoriteSongs = favoriteTracksData.docs;
      });
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getFavoriteMeditateSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: favoriteSongs.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Get.toNamed('/user/meditate/track',
                  arguments: [favoriteSongs[index], 'favorite']);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 2, color: Colors.black12))),
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
                      favoriteSongs[index]["CoverUrl"],
                      fit: BoxFit.cover,
                      alignment: const Alignment(1.5, 0),
                    ),
                  ),
                ),
                title: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(favoriteSongs[index]["Title"],
                        style: const TextStyle(fontWeight: FontWeight.w500))),
                subtitle: Text(
                  favoriteSongs[index]["Description"],
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: IconButton(
                    color: Colors.white,
                    onPressed: () {
                      Get.toNamed('/meditate/track',
                          arguments: [favoriteSongs[index], 'favorite']);
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
    );
  }
}
