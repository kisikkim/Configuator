import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


Future<Map> loadJson() async {
  final String rawJson = await rootBundle.loadString('assets/android.mobile.us');
  return JSON.decode(rawJson);
}

Future<String> getRawJson() async {
  final String rawJson = await rootBundle.loadString('assets/android.mobile.us', cache: false );
  return rawJson;
}