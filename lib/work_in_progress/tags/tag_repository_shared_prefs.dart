import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../identifiable.dart';
import 'i_tag_repository.dart';
import 'tag.dart';

class TagRepositorySharedPrefs implements ITagRepository {
  static const String _storageKey = 'tags';

  final StreamController<List<Tag>> _controller;
  final SharedPreferences _prefs;

  TagRepositorySharedPrefs._(this._prefs)
      : _controller = StreamController<List<Tag>>.broadcast() {
    _controller.onListen = _refreshStream;
  }

  static Future<TagRepositorySharedPrefs> create() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return TagRepositorySharedPrefs._(prefs);
  }

  @override
  Stream<List<Tag>> get stream => _controller.stream;

  String _encodeTag(Tag tag) {
    final Map<String, dynamic> tagMap = tag.toJson();
    return json.encode(tagMap);
  }

  Tag _decodeTag(String encodedTag) {
    final Map<String, dynamic> tagMap = json.decode(encodedTag);
    return Tag.fromJson(tagMap);
  }

  @override
  Future<void> addTag(Tag tag) async {
    final String encodedTag = _encodeTag(tag);
    List<String> tags = _prefs.getStringList(_storageKey) ?? [];
    tags.add(encodedTag);
    await _prefs.setStringList(_storageKey, tags);

    await _refreshStream();
  }

  @override
  Future<void> addTagToObject(Identifiable object, Tag tag) async {
    final String objectKey = '${object.id}_tags';
    List<String> objectTags = _prefs.getStringList(objectKey) ?? [];
    objectTags.add(tag.id);
    await _prefs.setStringList(objectKey, objectTags);

    await _refreshStream();
  }

  @override
  Future<void> removeTagFromObject(Identifiable object, Tag tag) async {
    final String objectKey = '${object.id}_tags';
    List<String> objectTags = _prefs.getStringList(objectKey) ?? [];
    objectTags.remove(tag.id);
    await _prefs.setStringList(objectKey, objectTags);

    await _refreshStream();
  }

  @override
  Future<void> removeTag(Tag tag) async {
    List<String> tags = _prefs.getStringList(_storageKey) ?? [];
    tags.removeWhere((t) => Tag.fromJson(json.decode(t)).id == tag.id);
    await _prefs.setStringList(_storageKey, tags);

    // Remove tag from all objects
    final keys = _prefs.getKeys();
    for (String key in keys) {
      if (key.endsWith('_tags')) {
        List<String> objectTags = _prefs.getStringList(key) ?? [];
        objectTags.remove(tag.id);
        await _prefs.setStringList(key, objectTags);
      }
    }

    await _refreshStream();
  }

  @override
  Future<Set<Tag>> getAllTags() async {
    final List<String>? encodedTags = _prefs.getStringList(_storageKey);
    if (encodedTags == null) {
      return {};
    }
    final tags =
        encodedTags.map((encodedTag) => _decodeTag(encodedTag)).toSet();
    return tags;
  }

  @override
  Future<Set<Tag>> getTagsForObject(Identifiable object) async {
    final String objectKey = '${object.id}_tags';
    final List<String>? tagIds = _prefs.getStringList(objectKey);
    if (tagIds == null) {
      return {};
    }
    final allTags = await getAllTags();
    final tags = allTags.where((tag) => tagIds.contains(tag.id)).toSet();
    return tags;
  }

  @override
  Future<Set<Identifiable>> getObjectsWithTag(
    Iterable<Identifiable> listOfAvailableObjects,
    Tag tag,
  ) async {
    final Set<Identifiable> objectsWithTag = {};
    for (final object in listOfAvailableObjects) {
      final String objectKey = '${object.id}_tags';
      final List<String>? tagIds = _prefs.getStringList(objectKey);
      if (tagIds != null && tagIds.contains(tag.id)) {
        objectsWithTag.add(object);
      }
    }
    return objectsWithTag;
  }

  Future<void> _refreshStream() async {
    final List<Tag> tags = (await getAllTags()).toList();
    _controller.add(tags);
  }
}
