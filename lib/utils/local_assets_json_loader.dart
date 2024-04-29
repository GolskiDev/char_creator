import 'dart:convert';

import 'package:flutter/services.dart';

class LocalAssetsJsonLoader {
  static Future<Map<String, dynamic>> loadJson(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString);
  }
}
