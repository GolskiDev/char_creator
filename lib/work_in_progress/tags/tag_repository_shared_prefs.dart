import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../identifiable.dart';
import 'i_tag_repository.dart';
import 'tag.dart';
import 'tag_associacion_model.dart';

class TagRepositorySharedPrefs implements ITagRepository {
  static const String _storageKey = 'tags';
  static const String _associationKey = 'tag_associations';

  final StreamController<List<Tag>> _controller;
  final SharedPreferences _prefs;

  TagRepositorySharedPrefs(SharedPreferences prefs)
      : _controller = StreamController<List<Tag>>.broadcast(),
        _prefs = prefs {
    _controller.onListen = _refreshStream;
  }

  @override
  Stream<List<Tag>> get stream => _controller.stream;

  String _encodeTag(Tag tag) => json.encode(tag.toJson());

  Tag _decodeTag(String encodedTag) => Tag.fromJson(json.decode(encodedTag));

  String _encodeAssociation(TagAssociacionModel association) =>
      json.encode(association.toJson());

  TagAssociacionModel _decodeAssociation(String encodedAssociation) =>
      TagAssociacionModel.fromJson(json.decode(encodedAssociation));

  @override
  Future<void> addTag(Tag tag) async {
    final String encodedTag = _encodeTag(tag);
    final tags = _prefs.getStringList(_storageKey) ?? [];
    tags.add(encodedTag);
    await _prefs.setStringList(_storageKey, tags);
    await _refreshStream();
  }

  @override
  Future<void> addTagToObject(Identifiable object, Tag tag) async {
    final String encodedAssociation = _encodeAssociation(
      TagAssociacionModel(
        tagId: tag.id,
        associacionId: object.id,
      ),
    );
    final associations = _prefs.getStringList(_associationKey) ?? [];
    associations.add(encodedAssociation);
    await _prefs.setStringList(_associationKey, associations);
    await _refreshStream();
  }

  @override
  Future<void> removeTagFromObject(Identifiable object, Tag tag) async {
    final associations = _prefs.getStringList(_associationKey) ?? [];
    final updatedAssociations = associations.where((encodedAssociation) {
      final association = _decodeAssociation(encodedAssociation);
      return !(association.tagId == tag.id &&
          association.associacionId == object.id);
    }).toList();
    await _prefs.setStringList(_associationKey, updatedAssociations);
    await _refreshStream();
  }

  @override
  Future<void> removeTag(Tag tag) async {
    final tags = _prefs.getStringList(_storageKey) ?? [];
    final updatedTags = tags.where((encodedTag) {
      final decodedTag = _decodeTag(encodedTag);
      return decodedTag.id != tag.id;
    }).toList();
    await _prefs.setStringList(_storageKey, updatedTags);

    // Remove tag from all associations
    final associations = _prefs.getStringList(_associationKey) ?? [];
    final updatedAssociations = associations.where((encodedAssociation) {
      final association = _decodeAssociation(encodedAssociation);
      return association.tagId != tag.id;
    }).toList();
    await _prefs.setStringList(_associationKey, updatedAssociations);

    await _refreshStream();
  }

  @override
  Future<Set<Tag>> getAllTags() async {
    final encodedTags = _prefs.getStringList(_storageKey);
    if (encodedTags == null) {
      return {};
    }
    return encodedTags.map(_decodeTag).toSet();
  }

  @override
  Future<Set<Tag>> getTagsForObject(Identifiable object) async {
    final encodedAssociations = _prefs.getStringList(_associationKey);
    if (encodedAssociations == null) {
      return {};
    }
    final associations = encodedAssociations
        .map(_decodeAssociation)
        .where((association) => association.associacionId == object.id)
        .toList();
    final allTags = await getAllTags();
    return allTags
        .where((tag) =>
            associations.any((association) => association.tagId == tag.id))
        .toSet();
  }

  @override
  Future<Set<Identifiable>> getObjectsWithTag(
    Iterable<Identifiable> listOfAvailableObjects,
    Tag tag,
  ) async {
    final encodedAssociations = _prefs.getStringList(_associationKey);
    if (encodedAssociations == null) {
      return {};
    }
    final associations = encodedAssociations
        .map(_decodeAssociation)
        .where((association) => association.tagId == tag.id)
        .toList();
    return listOfAvailableObjects
        .where((object) => associations
            .any((association) => association.associacionId == object.id))
        .toSet();
  }

  Future<void> _refreshStream() async {
    final tags = (await getAllTags()).toList();
    _controller.add(tags);
  }
}
