import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safe_place_app/view/screens/auth/login_screen.dart';
import 'package:safe_place_app/view_model/auth/login_view_model.dart';
import 'package:safe_place_app/view_model/auth/register_view_model.dart';
import 'package:safe_place_app/view_model/user/meditate_media_player_view_model.dart';
import 'package:safe_place_app/view_model/user/meditate_view_model.dart';
import 'package:safe_place_app/view_model/user/home_view_model.dart';
import 'firebase_options.dart';

Future<void> main() async {
  final String localeName = Intl.canonicalizedLocale('id_ID');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting(localeName, null)
      .then((_) => runApp(const SafePlaceApp()));
}

class SafePlaceApp extends StatelessWidget {
  const SafePlaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => UserHomeViewModel()),
        ChangeNotifierProvider(create: (_) => UserMeditateViewModel()),
        ChangeNotifierProvider(
            create: (_) => UserMeditateMediaPlayerViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Safe Place App',
        theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
