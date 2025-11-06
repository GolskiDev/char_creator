import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';

void main() async {
  final filePath = '../assets/daily_messages_spells.json';
  final file = File(filePath);

  if (!await file.exists()) {
    print('File not found: $filePath');
    return;
  }

  final content = await file.readAsString();
  final List<dynamic> messages = jsonDecode(content);
  final uuid = Uuid();

  bool updated = false;

  for (final message in messages) {
    if (message is Map<String, dynamic> && !message.containsKey('id')) {
      message['id'] = uuid.v4();
      updated = true;
    }
  }

  if (updated) {
    final encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(messages));
    print('Added missing ids.');
  } else {
    print('No missing ids found.');
  }
}
