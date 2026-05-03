import 'package:spells_and_tools_texts/spells_and_tools_texts.dart';
import 'package:spells_and_tools_texts/src/services/llm_client.dart';
import 'package:spells_and_tools_texts/src/services/spell_storage_service.dart';

class FakeSpellStorageService extends SpellStorageService {
  List<SpellTextResult> savedResults = [];

  @override
  Future<List<SpellTextResult>> loadAll() async => List.of(savedResults);

  @override
  Future<void> saveAll(List<SpellTextResult> results) async {
    savedResults = List.of(results);
  }
}

class FakeLlmClient implements LlmClient {
  final String response;

  FakeLlmClient({this.response = 'fake response'});

  @override
  Future<String> generate(String prompt) async => response;
}
