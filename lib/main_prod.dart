import 'package:spells_and_tools/firebase_options_prod.dart';

import 'main.dart';

/// These differ only by the firebase options used to initialize firebase
/// THIS IS PROD VERSION
void main() async {
  runMainApp(DefaultFirebaseOptions.currentPlatform);
}
