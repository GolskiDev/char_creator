import 'dart:async';
import '../identifiable.dart';
import 'tag.dart';

abstract class ITagRepository {
  Stream<List<Tag>> get stream;

  void addTag(Tag tag);
  void addTagToObject(Identifiable object, Tag tag);
  void removeTagFromObject(Identifiable object, Tag tag);
  void removeTag(Tag tag);
  Future<Set<Tag>> getAllTags();
  Future<Set<Tag>> getTagsForObject(Identifiable object);
  Future<Set<Identifiable>> getObjectsWithTag(
    Iterable<Identifiable> listOfAvailableObjects,
    Tag tag,
  );
}
