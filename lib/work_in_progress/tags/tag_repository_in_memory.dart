import '../identifiable.dart';
import 'i_tag_repository.dart';
import 'tag.dart';

class TagRepository implements ITagRepository {
  final Map<String, Tag> _tags = {};
  final Map<String, Set<String>> _tagAssociations = {};

  @override
  // TODO: implement stream
  Stream<List<Tag>> get stream => throw UnimplementedError();

  @override
  void addTag(Tag tag) {
    _tags[tag.id] = tag;
  }

  @override
  void addTagToObject(Identifiable object, Tag tag) {
    _tagAssociations.putIfAbsent(object.id, () => {}).add(tag.id);
  }

  @override
  void removeTagFromObject(Identifiable object, Tag tag) {
    _tagAssociations[object.id]?.remove(tag.id);
  }

  @override
  void removeTag(Tag tag) {
    _tags.remove(tag.id);
    _tagAssociations.forEach((key, tags) {
      tags.remove(tag.id);
    });
  }

  @override
  Future<Set<Tag>> getAllTags() {
    return Future.value(_tags.values.toSet());
  }

  @override
  Future<Set<Tag>> getTagsForObject(Identifiable object) {
    final tagIds = _tagAssociations[object.id] ?? {};
    return Future.value(tagIds.map((id) => _tags[id]!).toSet());
  }

  @override
  Future<Set<Identifiable>> getObjectsWithTag(
    Iterable<Identifiable> listOfAvailableObjects,
    Tag tag,
  ) {
    return Future.value(listOfAvailableObjects.where((object) {
      return _tagAssociations[object.id]?.contains(tag.id) ?? false;
    }).toSet());
  }
}
