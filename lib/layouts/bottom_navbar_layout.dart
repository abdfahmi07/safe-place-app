import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:safe_place_app/screens/home/home_screen.dart';
import 'package:safe_place_app/screens/journal/journal_screen.dart';
import 'package:safe_place_app/screens/meditate/meditate_screen.dart';

class BottomNavbarLayout extends StatefulWidget {
  const BottomNavbarLayout({super.key});

  @override
  State<BottomNavbarLayout> createState() => _BottomNavbarLayoutState();
}

class _BottomNavbarLayoutState extends State<BottomNavbarLayout> {
  String _appBarTitle = 'Safe Place';
  int _currentPage = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const MeditateScreen(),
    const JournalScreen()
  ];

  void _onMenuTapped(int index) {
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
          _appBarTitle = 'Journal';
          break;
        default:
          _appBarTitle = '';
          break;
      }
    });
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
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: GNav(
              backgroundColor: Colors.white,
              color: const Color(0xFFA2A3A5),
              activeColor: Colors.black,
              onTabChange: _onMenuTapped,
              selectedIndex: _currentPage,
              gap: 8,
              iconSize: 30,
              tabs: const [
                GButton(icon: Iconsax.home),
                GButton(icon: Iconsax.music),
                GButton(icon: Iconsax.book),
              ],
            ),
          ),
        ));
  }
}
