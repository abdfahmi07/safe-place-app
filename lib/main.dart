import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:safe_place_app/layouts/bottom_navbar_layout.dart';
import 'package:safe_place_app/screens/home/home_screen.dart';
import 'package:safe_place_app/screens/journal/journal_screen.dart';
import 'package:safe_place_app/screens/meditate/meditate_player_screen.dart';
import 'package:safe_place_app/screens/meditate/meditate_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safe Place App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const BottomNavbarLayout(),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/meditate', page: () => const MeditateScreen()),
        GetPage(
            name: '/meditate/track', page: () => const MeditatePlayerScreen()),
        GetPage(name: '/journal', page: () => const JournalScreen()),
      ],
    );
  }
}
