import 'dart:async';

import '../identifiable.dart';
import 'tag.dart';

abstract class ITagRepository {
  Stream<List<Tag>> get stream;

  Future<void> addTag(Tag tag);
  Future<void> addTagToObject(Identifiable object, Tag tag);
  Future<void> removeTagFromObject(Identifiable object, Tag tag);
  Future<void> removeTag(Tag tag);
  Future<Set<Tag>> getAllTags();
  Future<Set<Tag>> getTagsForObject(Identifiable object);
  Future<Set<Identifiable>> getObjectsWithTag(
    Iterable<Identifiable> listOfAvailableObjects,
    Tag tag,
  );

  Future<void> addTagsToObject(
    Identifiable object,
    Iterable<Tag> tags,
  );
}
