import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:safe_place_app/view/layouts/admin/admin_bottom_navbar_layout.dart';
import 'package:safe_place_app/model/song_model.dart';

class AdminMeditateAddScreen extends StatefulWidget {
  const AdminMeditateAddScreen({super.key});

  @override
  State<AdminMeditateAddScreen> createState() => _AdminMeditateAddScreenState();
}

class _AdminMeditateAddScreenState extends State<AdminMeditateAddScreen> {
  final Reference _storageRef = FirebaseStorage.instance.ref();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  File? coverImagePreview;
  String? coverImageUrl;
  String? musicFileName;
  String? musicUrl;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> pickCoverImage() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final File imageTemp = File(image.path);

      uploadCoverImage(image: imageTemp, imagePath: image.path);

      setState(() {
        coverImagePreview = imageTemp;
      });
    } on PlatformException catch (err) {
      debugPrint(err.toString());
    }
  }

  Future<void> pickMusicFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result == null) return;

    PlatformFile platformFile = result.files.first;
    File file = File(platformFile.path!);

    uploadMusicFile(file: file, filePath: platformFile.path!);

    setState(() {
      musicFileName = platformFile.name;
    });
  }

  Future<void> uploadCoverImage(
      {required File image, required String imagePath}) async {
    final metadata = SettableMetadata(contentType: "image/jpeg");
    final uploadTask = _storageRef.child(imagePath).putFile(image, metadata);
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          debugPrint("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          debugPrint("Upload is paused.");
          break;
        case TaskState.canceled:
          debugPrint("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          setState(() async {
            coverImageUrl = await taskSnapshot.ref.getDownloadURL();
          });
          break;
      }
    });
  }

  Future<void> uploadMusicFile(
      {required File file, required String filePath}) async {
    final uploadTask = _storageRef.child(filePath).putFile(file);
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          debugPrint("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          debugPrint("Upload is paused.");
          break;
        case TaskState.canceled:
          debugPrint("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          setState(() async {
            musicUrl = await taskSnapshot.ref.getDownloadURL();
          });
          break;
      }
    });
  }

  Future createNewTrack() async {
    final SongModel song = SongModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        url: musicUrl!,
        coverUrl: coverImageUrl!,
        createdAt: DateTime.parse(
            DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())),
        isFavorited: false);

    try {
      await _db.collection("Tracks").add(song.toJson());

      Get.offAll(() => const AdminBottomNavbarLayout(
            page: 1,
            appBarTitle: 'Meditate',
          ));
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Add Track',
              style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 15),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1.5, color: const Color(0xFFF0F5F8))),
                          height: coverImagePreview == null ? 80 : 350,
                          width: double.infinity,
                          child: coverImagePreview == null
                              ? InkWell(
                                  onTap: pickCoverImage,
                                  child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Iconsax.gallery_add,
                                            color: Color(0xFFE6984C)),
                                        SizedBox(width: 10),
                                        Text('Upload Cover',
                                            style: TextStyle(
                                                color: Color(0xFFAEABBB),
                                                fontWeight: FontWeight.w400))
                                      ]),
                                )
                              : Stack(children: [
                                  Image.file(
                                    coverImagePreview!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            coverImagePreview = null;
                                          });
                                        },
                                        icon: const Icon(Iconsax.close_circle),
                                        iconSize: 35,
                                        color: const Color(0xFFE6984C),
                                      ),
                                    ),
                                  )
                                ])),
                      const SizedBox(height: 20),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  width: 1.5, color: const Color(0xFFF0F5F8))),
                          height: 80,
                          width: double.infinity,
                          child: InkWell(
                            onTap: pickMusicFile,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Iconsax.music,
                                      color: Color(0xFFE6984C)),
                                  const SizedBox(width: 10),
                                  Text(musicFileName ?? 'Upload Song',
                                      softWrap: true,
                                      style: const TextStyle(
                                          color: Color(0xFFAEABBB),
                                          fontWeight: FontWeight.w400))
                                ]),
                          )),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20, right: 10),
                              child:
                                  Icon(Iconsax.tag, color: Color(0xFFE6984C)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1.5, color: Color(0xFFF0F5F8))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1.5, color: Color(0xFFE6984C))),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.redAccent)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.redAccent)),
                            contentPadding: const EdgeInsets.all(20),
                            hintText: 'Title',
                            hintStyle: const TextStyle(
                                color: Color(0xFFAEABBB),
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                            errorMaxLines: 3),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter title';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 20, right: 10),
                              child: Icon(Iconsax.note_text,
                                  color: Color(0xFFE6984C)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1.5, color: Color(0xFFF0F5F8))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1.5, color: Color(0xFFE6984C))),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.redAccent)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.redAccent)),
                            contentPadding: const EdgeInsets.all(20),
                            hintText: 'Description',
                            hintStyle: const TextStyle(
                                color: Color(0xFFAEABBB),
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                            errorMaxLines: 3),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color(0xFFF2AC66),
                                ),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            onPressed: createNewTrack,
                            child: const Text('Submit',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600))),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
