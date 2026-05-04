# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`spells_and_tools_texts` is a Flutter package that generates LLM-powered texts for spell images. It ships built-in integrations for OpenAI, Anthropic, and Ollama (via `langchain_dart`). The host app configures it with a provider and API key — no LLM SDK code required in the host.

## Commands

```bash
# Get dependencies
flutter pub get

# Analyze for lint errors
flutter analyze

# Run unit tests
flutter test

# Run a single test file
flutter test test/spells_and_tools_texts_test.dart
```

## Architecture

```
lib/
├── spells_and_tools_texts.dart     ← public barrel export
└── src/
    ├── models/
    │   ├── spell_text_result.dart  ← data class with toJson/fromJson
    │   ├── spell_text_status.dart  ← enum: pending | accepted | dismissed
    │   └── spells_config.dart      ← config: provider, apiKey, model, baseUrl
    ├── services/
    │   ├── llm_provider.dart       ← enum: openAI | anthropic | ollama
    │   ├── llm_client.dart         ← internal abstract interface (not exported)
    │   ├── llm_client_factory.dart ← builds the correct langchain_dart model
    │   ├── spell_storage_service.dart ← JSON file persistence via path_provider
    │   └── spell_text_service.dart ← orchestrates generation, state, storage
    └── widgets/
        ├── spell_texts_list_view.dart ← scrollable list with optional export button
        └── spell_text_card.dart    ← single result card with Accept/Dismiss buttons
```

### Key design decisions

- **`LlmClient`** (`src/services/llm_client.dart`) is an internal abstract class wrapping langchain. Tests inject a `FakeLlmClient` via the `llmClientOverride` constructor param on `SpellTextService` — tests never hit a real LLM.
- **`SpellStorageService`** reads/writes `<documents>/spell_text_results.json`. It's a class (not a singleton) so tests can inject `FakeSpellStorageService` (defined in `test/fake_spell_storage_service.dart`).
- All results (pending, accepted, dismissed) are persisted. Export only returns accepted ones.
- The list widget uses plain `StatefulWidget` + `setState` — no state management library.

### Host app usage

```dart
// Once at startup:
final service = SpellTextService(
  config: SpellsConfig(
    provider: LlmProvider.anthropic,
    apiKey: 'sk-ant-...',
    model: 'claude-3-haiku-20240307',
  ),
  onAccepted: (result) { /* handle in host app */ },
);
await service.init(); // loads persisted results

// In the widget tree:
SpellTextsListView(
  service: service,
  showExportButton: true,
  onExport: (json) { /* share or save the JSON */ },
)

// To generate text:
await service.generate(
  spellTitle: 'Fireball',
  spellDescription: '...',
  prompt: 'Your full prompt here',
);
```
