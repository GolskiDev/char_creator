import 'dart:convert';
import 'dart:developer';

import 'package:char_creator/features/documents/document.dart';
import 'package:flutter/services.dart' show rootBundle;

class StaticDocumentDataSource {
  Future<List<Document>> loadDocuments() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/documents.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => Document.fromJson(json)).toList();
    } catch (e) {
      log(
        e.toString(),
      );
      return [];
    }
  }
}
