import 'dart:async';
import 'dart:convert';

import 'package:char_creator/features/documents/static_document_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:char_creator/features/documents/document.dart';

class DocumentRepository {
  static const String _storageKey = 'documents';

  Stream<List<Document>> get stream => _controller.stream;

  final StreamController<List<Document>> _controller;
  final StaticDocumentDataSource _staticDataSource;

  DocumentRepository(
    this._staticDataSource,
  ) : _controller = StreamController<List<Document>>.broadcast() {
    _controller.onListen = _refreshStream;
  }

  String _encodeDocument(Document document) {
    final Map<String, dynamic> documentMap = document.toJson();
    return json.encode(documentMap);
  }

  Document _decodeDocument(String encodedDocument) {
    final Map<String, dynamic> documentMap = json.decode(encodedDocument);
    return Document.fromJson(documentMap);
  }

  Future<void> saveDocument(Document document) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedDocument = _encodeDocument(document);
    List<String> documents = prefs.getStringList(_storageKey) ?? [];
    documents.add(encodedDocument);
    await prefs.setStringList(_storageKey, documents);

    await _refreshStream();
  }

  Future<List<Document>> getAllDocuments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<Document> staticDocuments =
        await _staticDataSource.loadDocuments();

    final List<String>? encodedDocuments = prefs.getStringList(_storageKey);
    final sharedPrefsDocuments = encodedDocuments ?? [];

    final documents = sharedPrefsDocuments
        .map((encodedDocument) => _decodeDocument(encodedDocument))
        .toList();

    return [
      ...staticDocuments,
      ...documents,
    ];
  }

  Future<void> updateDocument(Document updatedDocument) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> documents = prefs.getStringList(_storageKey) ?? [];
    final int index = documents.indexWhere(
        (d) => Document.fromJson(json.decode(d)).id == updatedDocument.id);
    if (index != -1) {
      documents[index] = _encodeDocument(updatedDocument);
      await prefs.setStringList(_storageKey, documents);
    }

    await _refreshStream();
  }

  Future<void> deleteDocument(String documentId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> documents = prefs.getStringList(_storageKey) ?? [];
    documents
        .removeWhere((d) => Document.fromJson(json.decode(d)).id == documentId);
    await prefs.setStringList(_storageKey, documents);

    await _refreshStream();
  }

  Future<void> _refreshStream() async {
    final List<Document> documents = await getAllDocuments();
    print('refreshing stream with ${documents.length} documents');
    _controller.add(documents);
  }
}
