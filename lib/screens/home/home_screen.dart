import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // debugPrint('=> ${quote.toString()}');
    return Container(
      // decoration: const BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage("assets/images/Perlin-2.png"),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 5),
              Text('Welcome Back, Abdul!',
                  style: GoogleFonts.playfairDisplay(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  )
                  // TextStyle(
                  //     fontWeight: FontWeight.w600,
                  //     fontSize: 21,
                  //      )
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Recommended Morning Track.',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 8),
                                      child: Text('3 min',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        foregroundColor: Colors.white,
                                        padding:
                                            const EdgeInsets.only(right: 20)),
                                    onPressed: () {},
                                    icon:
                                        const Icon(Icons.play_circle, size: 40),
                                    label: const Text('Play',
                                        style: TextStyle(fontSize: 16)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: SvgPicture.asset(
                              'assets/images/music-guitar-2.svg',
                              height: 200,
                              semanticsLabel: 'Recommendation Meditate',
                              fit: BoxFit.cover,
                              alignment: const Alignment(0, -8),
                            ),
                          )
                        ]),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text('Explore Moods',
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       // gradient: const LinearGradient(
                  //       //   begin: Alignment.topLeft,
                  //       //   end: Alignment.bottomRight,
                  //       //   stops: [0.5, 0],
                  //       //   colors: [Color(0xFFFFF3DD), Color(0xFF225560)],
                  //       // ),
                  //       color: const Color(0xFFFFF3DD),
                  //       borderRadius: BorderRadius.circular(10)),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(20),
                  //     child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(quote['quote'],
                  //               style: const TextStyle(
                  //                   color: Colors.black,
                  //                   fontSize: 13.5,
                  //                   fontWeight: FontWeight.w400)),
                  //           const SizedBox(height: 10),
                  //           Text("- ${quote['author']}",
                  //               style: const TextStyle(
                  //                   color: Colors.black,
                  //                   fontSize: 13.5,
                  //                   fontWeight: FontWeight.w400)),
                  //         ]),
                  //   ),
                  // ),
                  // const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 200,
                          decoration: BoxDecoration(
                              color: const Color(0xFFFFF3DD),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text('Meditate.',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SvgPicture.asset(
                                      'assets/images/meditate.svg',
                                      semanticsLabel: 'Meditation Menu',
                                      alignment: const Alignment(0, 0.25),
                                      fit: BoxFit.cover),
                                )
                              ]),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 200,
                          decoration: BoxDecoration(
                              color: const Color(0xFFFFF3DD),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text('Journal.',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: SvgPicture.asset(
                                      'assets/images/journal-2.svg',
                                      semanticsLabel: 'Journaling Menu',
                                      alignment: const Alignment(0, -1.25),
                                      fit: BoxFit.cover),
                                )
                              ]),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20)
            ],
          )),
    );
  }
}
