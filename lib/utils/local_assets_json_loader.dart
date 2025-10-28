import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class LocalAssetsJsonLoader {
  static Future<Map<String, dynamic>> loadJson(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final result = await compute(jsonDecode, jsonString);
    return Map<String, dynamic>.from(result);
  }
}
