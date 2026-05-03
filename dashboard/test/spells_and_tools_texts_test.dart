import 'package:flutter_test/flutter_test.dart';
import 'package:spells_and_tools_texts/spells_and_tools_texts.dart';

import 'fake_spell_storage_service.dart';

final _fireball = const Spell(
  id: 'spell-1',
  title: 'Fireball',
  description: 'A ball of roaring fire.',
);

final _icebolt = const Spell(
  id: 'spell-2',
  title: 'Icebolt',
  description: 'A shard of enchanted ice.',
);

PromptTemplate _template(String text) => PromptTemplate(
      id: 'pt-1',
      text: text,
      createdAt: DateTime(2024),
    );

SpellTextService _makeService({
  FakeSpellStorageService? storage,
  void Function(SpellTextResult)? onAccepted,
  void Function(SpellTextResult)? onDismissed,
}) {
  storage ??= FakeSpellStorageService();
  return SpellTextService(
    config: const SpellsConfig(
      provider: LlmProvider.openAI,
      apiKey: 'test',
      model: 'gpt-4o-mini',
    ),
    storage: storage,
    llmClientOverride: FakeLlmClient(),
    onAccepted: onAccepted,
    onDismissed: onDismissed,
  );
}

void main() {
  group('PromptTemplate', () {
    test('resolve substitutes all placeholders', () {
      final t = _template(
        'Joke about {{title}} (id={{id}}): {{description}}',
      );
      final resolved = t.resolve(_fireball);
      expect(resolved, 'Joke about Fireball (id=spell-1): A ball of roaring fire.');
    });

    test('resolve leaves unrecognised placeholders intact', () {
      final t = _template('Hello {{unknown}}');
      expect(t.resolve(_fireball), 'Hello {{unknown}}');
    });

    test('preview truncates long text', () {
      final t = _template('A' * 70);
      expect(t.preview.length, 60);
      expect(t.preview.endsWith('…'), isTrue);
    });
  });

  group('SpellTextService', () {
    late FakeSpellStorageService storage;
    late SpellTextService service;

    setUp(() async {
      storage = FakeSpellStorageService();
      service = _makeService(storage: storage);
      await service.init();
    });

    test('starts empty after init', () {
      expect(service.results, isEmpty);
    });

    test('generate adds a pending result with correct spellId', () async {
      final result = await service.generate(
        spell: _fireball,
        promptTemplate: _template('Write a joke about {{title}}.'),
      );

      expect(service.results.length, 1);
      expect(result.status, SpellTextStatus.pending);
      expect(result.spellId, _fireball.id);
      expect(result.spellTitle, 'Fireball');
      expect(result.generatedText, 'fake response');
    });

    test('accept updates status and fires callback', () async {
      SpellTextResult? accepted;
      final svc = _makeService(storage: storage, onAccepted: (r) => accepted = r);
      await svc.init();

      final result = await svc.generate(
        spell: _fireball,
        promptTemplate: _template('prompt'),
      );
      await svc.accept(result.id);

      expect(svc.results.first.status, SpellTextStatus.accepted);
      expect(accepted?.id, result.id);
    });

    test('dismiss updates status and fires callback', () async {
      SpellTextResult? dismissed;
      final svc = _makeService(storage: storage, onDismissed: (r) => dismissed = r);
      await svc.init();

      final result = await svc.generate(
        spell: _icebolt,
        promptTemplate: _template('prompt'),
      );
      await svc.dismiss(result.id);

      expect(svc.results.first.status, SpellTextStatus.dismissed);
      expect(dismissed?.id, result.id);
    });

    test('accept after dismiss flips status and fires onAccepted', () async {
      SpellTextResult? accepted;
      final svc = _makeService(storage: storage, onAccepted: (r) => accepted = r);
      await svc.init();

      final result = await svc.generate(
        spell: _fireball,
        promptTemplate: _template('prompt'),
      );
      await svc.dismiss(result.id);
      expect(svc.results.first.status, SpellTextStatus.dismissed);

      await svc.accept(result.id);
      expect(svc.results.first.status, SpellTextStatus.accepted);
      expect(accepted?.id, result.id);
    });

    test('dismiss after accept flips status and fires onDismissed', () async {
      SpellTextResult? dismissed;
      final svc = _makeService(storage: storage, onDismissed: (r) => dismissed = r);
      await svc.init();

      final result = await svc.generate(
        spell: _fireball,
        promptTemplate: _template('prompt'),
      );
      await svc.accept(result.id);
      expect(svc.results.first.status, SpellTextStatus.accepted);

      await svc.dismiss(result.id);
      expect(svc.results.first.status, SpellTextStatus.dismissed);
      expect(dismissed?.id, result.id);
    });

    test('exportAcceptedToJson only includes accepted results', () async {
      final r1 = await service.generate(
        spell: _fireball,
        promptTemplate: _template('p'),
      );
      final r2 = await service.generate(
        spell: _icebolt,
        promptTemplate: _template('p'),
      );
      await service.accept(r1.id);

      final json = service.exportAcceptedToJson();
      expect(json, contains(r1.id));
      expect(json, isNot(contains(r2.id)));
    });

    test('persisted results are loaded on init', () async {
      final r = await service.generate(
        spell: _fireball,
        promptTemplate: _template('p'),
      );

      final service2 = _makeService(storage: storage);
      await service2.init();
      expect(service2.results.length, 1);
      expect(service2.results.first.id, r.id);
    });

    test('generateBatch creates spells × count results', () async {
      await service.generateBatch(
        spells: [_fireball, _icebolt],
        promptTemplate: _template('p'),
        count: 3,
      );
      expect(service.results.length, 6);
    });

    test('resultsForSpell filters correctly', () async {
      await service.generate(spell: _fireball, promptTemplate: _template('p'));
      await service.generate(spell: _icebolt, promptTemplate: _template('p'));
      await service.generate(spell: _fireball, promptTemplate: _template('p'));

      final fireballResults = service.resultsForSpell(_fireball.id);
      expect(fireballResults.length, 2);
      expect(fireballResults.every((r) => r.spellId == _fireball.id), isTrue);
    });
  });
}
