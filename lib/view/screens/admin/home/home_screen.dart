import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_place_app/model/user_model.dart';
import 'package:shimmer/shimmer.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<AdminHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? displayName;
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

  Future<UserModel?> getCurrentUser() async {
    final userEmail = _auth.currentUser?.email;

    if (userEmail != null) {
      return getUserDetails(userEmail);
    } else {
      Get.snackbar("Error", "Authentication Error");
    }

    return null;
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("Users").where("Email", isEqualTo: email).get();
    final userData =
        snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).single;

    return userData;
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
            const SizedBox(height: 5),
            FutureBuilder(
              future: getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final UserModel userData = snapshot.data as UserModel;
                    final String displayName = userData.fullName.split(' ')[0];

                    return Text('Welcome Back, $displayName',
                        style: GoogleFonts.playfairDisplay(
                          fontWeight: FontWeight.bold,
                          fontSize: 21,
                        ));
                  } else if (snapshot.hasError) {
                    return SnackBar(content: Text(snapshot.error.toString()));
                  } else {
                    return const SnackBar(content: Text("Unknown Error"));
                  }
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('How are you feeling today?',
                  style: GoogleFonts.playfairDisplay(
                      color: Colors.black45, fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: InkWell(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.465, 0],
                        colors: [Color(0xDA225560), Color(0xFFFFF3DD)],
                      ),
                      color: const Color(0xFFFFF3DD),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                      'Starting your journey with adding new tracks.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        foregroundColor:
                                            const Color(0xDA225560),
                                        padding:
                                            const EdgeInsets.only(right: 20)),
                                    onPressed: () {},
                                    icon: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: const Icon(Icons.add, size: 30)),
                                    label: const Text('Add',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 40, 20, 0),
                            child: SvgPicture.asset(
                              'assets/images/admin-1.svg',
                              semanticsLabel: 'Recommendation Meditate',
                              width: 180,
                              fit: BoxFit.cover,
                              alignment: const Alignment(1, -3),
                            ),
                          ),
                        )
                      ]),
                ),
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text('Recently Added',
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ]),
            const SizedBox(height: 5),
            songs.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      if (index != 3) {
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
                          ),
                        );
                      } else {
                        return null;
                      }
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
        ));
  }
}
