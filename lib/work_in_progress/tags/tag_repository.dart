import 'tag.dart';

class TagRepository {
  final storage = <Tag>[];

  Future<List<Tag>> getTags() async {
    await Future.delayed(const Duration(seconds: 1));
    return storage;
  }
}
