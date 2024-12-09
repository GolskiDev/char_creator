import 'package:char_creator/features/fields/field.dart';
import 'package:riverpod/riverpod.dart';

import '../documents/document.dart';
import '../fields/field_values/field_value.dart';

final chatContextProvider = StateProvider<ChatContext>(
  (ref) {
    return ChatContext.empty();
  },
);

class ChatContext {
  List<String> get referencedDocumentIds => contextValueKeys
      .map((contextValueKey) => contextValueKey.documentId)
      .toList();

  final List<ChatContextValueKey> contextValueKeys;

  const ChatContext._({
    required this.contextValueKeys,
  });

  factory ChatContext.empty() {
    return const ChatContext._(
      contextValueKeys: [],
    );
  }

  ChatContext addToContext({
    required Document document,
    required Field field,
    required StringValue stringValue,
  }) {
    final key = ChatContextValueKey.fromDocument(
      document: document,
      field: field,
      stringValue: stringValue,
    );

    return ChatContext._(
      contextValueKeys: [...contextValueKeys, key],
    );
  }

  ChatContext removeFromContext({
    required Document document,
    required Field field,
    required StringValue stringValue,
  }) {
    final key = ChatContextValueKey.fromDocument(
      document: document,
      field: field,
      stringValue: stringValue,
    );

    return ChatContext._(
      contextValueKeys:
          contextValueKeys.where((element) => element != key).toList(),
    );
  }

  ChatContext addKeyToContext({
    required ChatContextValueKey key,
  }) {
    return ChatContext._(
      contextValueKeys: [...contextValueKeys, key],
    );
  }

  ChatContext removeKeyFromContext({
    required ChatContextValueKey key,
  }) {
    return ChatContext._(
      contextValueKeys:
          contextValueKeys.where((element) => element != key).toList(),
    );
  }
}

class ChatContextValueKey {
  final String valueKey;
  String get documentId => valueKey.split('---').first;
  String get fieldName => valueKey.split('---').elementAt(1);
  String get stringValueHash => valueKey.split('---').last;

  const ChatContextValueKey._({
    required String documentId,
    required String fieldName,
    required String stringValueHash,
  }) : valueKey = '$documentId---$fieldName---$stringValueHash';

  factory ChatContextValueKey.fromDocument({
    required Document document,
    required Field field,
    required StringValue stringValue,
  }) {
    return ChatContextValueKey._(
      documentId: document.id,
      fieldName: field.name,
      stringValueHash: stringValue.value.hashCode.toString(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatContextValueKey && other.valueKey == valueKey;
  }

  @override
  int get hashCode => valueKey.hashCode;
}
