import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;

class ChatUtils {
  static chatTypes.User get chatUser {
    return const chatTypes.User(
      id: '1',
      firstName: 'User',
    );
  }

  static chatTypes.User get botUser {
    return const chatTypes.User(
      id: '2',
      firstName: 'Bot',
    );
  }

  static String get extractJsonPrompt {
    return '''
Based on this:
{input}

Extract any of the following traits
Here are ids for the traits you can extract:
- name
- race
- characterClass
- skills
- equipment
- alignment
- personalityTraits
- ideals
- bonds
- flaws
- appearance
- alliesAndOrganizations
- treasure
- characterHistory

return as JSON in the format:
{jsonFormat}       
''';
  }

  static String get jsonFormat {
    return '''
\{
  "character": \{
    "traitId": "traitValue"
    "traitId2": "traitValue2"
  \}
\}
''';
  }
}
