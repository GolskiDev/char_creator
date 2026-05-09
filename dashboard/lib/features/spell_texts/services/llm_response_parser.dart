import 'dart:convert';

/// Parses a raw LLM response string.
///
/// If the response looks like JSON and contains a `"text"` key with a string
/// value, extracts that as the generated text and returns any remaining fields
/// as metadata.
///
/// Falls back to treating the entire response as plain text if:
/// - The response is not valid JSON
/// - There is no `"text"` key (or its value is not a String)
/// - JSON parsing throws
({String text, Map<String, dynamic>? metadata}) parseLlmResponse(String raw) {
  final trimmed = raw.trim();
  if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map<String, dynamic> && decoded['text'] is String) {
        final text = decoded['text'] as String;
        final meta = Map<String, dynamic>.from(decoded)..remove('text');
        return (text: text, metadata: meta.isEmpty ? null : meta);
      }
    } catch (_) {
      // Not valid JSON — fall through to plain text
    }
  }
  return (text: trimmed, metadata: null);
}
