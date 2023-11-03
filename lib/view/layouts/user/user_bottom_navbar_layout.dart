import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:safe_place_app/view/screens/auth/login_screen.dart';
import 'package:safe_place_app/view/screens/user/favorite_meditate/favorite_meditate_screen.dart';
import 'package:safe_place_app/view/screens/user/home/home_screen.dart';
import 'package:safe_place_app/view/screens/user/meditate/meditate_screen.dart';

class UserBottomNavbarLayout extends StatefulWidget {
  const UserBottomNavbarLayout(
      {super.key, required this.appBarTitle, required this.page});

  final int page;
  final String appBarTitle;

  @override
  State<UserBottomNavbarLayout> createState() => _BottomNavbarLayoutState();
}

class _BottomNavbarLayoutState extends State<UserBottomNavbarLayout> {
  late String _appBarTitle;
  late int _currentPage;
  final List<Widget> _pages = [
    const UserHomeScreen(),
    const UserMeditateScreen(),
    const UserFavoriteMeditateScreen()
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.page;
    _appBarTitle = widget.appBarTitle;
  }

  void _onMenuTapped(int index) {
    if (index != 3) {
      setState(() {
        _currentPage = index;
        switch (_currentPage) {
          case 0:
            _appBarTitle = 'Safe Place';
            break;
          case 1:
            _appBarTitle = 'Meditate';
            break;
          case 2:
            _appBarTitle = 'Favorite';
            break;
          default:
            _appBarTitle = '';
            break;
        }
      });
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false);
    }
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('See you soon'),
          content: const Text('Are you sure this is what you want?'),
          backgroundColor: Colors.white,
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFFE6984C)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: signOut,
              child: const Text('Yes, i want',
                  style: TextStyle(color: Color(0xFFE6984C))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              SvgPicture.asset(
                'assets/logo/meditation-timer.svg',
                semanticsLabel: 'Safe Place App',
                width: 28,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(_appBarTitle,
                    style: GoogleFonts.playfairDisplay(
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        body: _pages[_currentPage],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              border:
                  Border(top: BorderSide(width: 2, color: Color(0xFFEBF0F4)))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GNav(
              backgroundColor: Colors.white,
              color: const Color(0xFFA2A3A5),
              activeColor: Colors.black,
              onTabChange: _onMenuTapped,
              selectedIndex: _currentPage,
              gap: 8,
              iconSize: 30,
              tabs: [
                const GButton(icon: Iconsax.home),
                const GButton(icon: Iconsax.music),
                const GButton(icon: Iconsax.heart),
                GButton(
                    icon: Iconsax.logout,
                    onPressed: () => _dialogBuilder(context)),
              ],
            ),
          ),
        ));
  }
}
