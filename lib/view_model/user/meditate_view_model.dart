import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class UserMeditateViewModel with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final dioInit = dio.Dio();

  Map<String, dynamic> quote = {};
  List<QueryDocumentSnapshot<Object?>> songs = [];

  Future<void> getMeditateSongs() async {
    try {
      final QuerySnapshot tracksData = await _db
          .collection("Tracks")
          .orderBy('CreatedAt', descending: true)
          .get();

      songs = tracksData.docs;
      notifyListeners();
    } catch (err) {
      throw Exception(err);
    }
  }

  void checkQuoteExp() async {
    try {
      final SharedPreferences prefs = await _prefs;
      String? quoteFromPrefs = prefs.getString('quote');

      if (quoteFromPrefs == null) {
        getQuote(prefs: prefs);
      } else {
        Map<String, dynamic> quoteDecoded = json.decode(quoteFromPrefs);
        final DateTime quoteCreatedAt =
            DateTime.parse(quoteDecoded['createdAt']);
        final DateTime currentDateTime = DateTime.parse(
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));
        final DateTime yesterday = DateTime(currentDateTime.year,
            currentDateTime.month, currentDateTime.day - 1);
        final DateTime formattedQuoteCreatedAt = DateTime(
            quoteCreatedAt.year, quoteCreatedAt.month, quoteCreatedAt.day);

        if (formattedQuoteCreatedAt == yesterday) {
          prefs.remove('quote');
          getQuote(prefs: prefs);
        } else {
          quote = quoteDecoded;
          notifyListeners();
        }
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  void getQuote({required SharedPreferences prefs}) async {
    try {
      final dio.Response response =
          await dioInit.get('https://api.api-ninjas.com/v1/quotes',
              options: dio.Options(headers: {
                'X-Api-Key': 't0uNkYR9cvfGeKam9CRW3A==sjfOFrL7bdoLJ2gJ',
              }),
              queryParameters: {'category': 'happiness'});
      final Map<String, dynamic> responseData = {
        ...response.data[0],
        "createdAt": DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())
      };
      prefs.setString('quote', json.encode(responseData));
      quote = responseData;
      notifyListeners();
    } catch (err) {
      throw Exception(err);
    }
  }
}
