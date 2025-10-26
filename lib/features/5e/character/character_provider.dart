import 'package:flutter/widgets.dart';

class SelectedCharacterIdProvider extends InheritedWidget {
  final String? selectedCharacterId;

  const SelectedCharacterIdProvider({
    super.key,
    required super.child,
    required this.selectedCharacterId,
  });

  static String? maybeOf(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<SelectedCharacterIdProvider>();
    return provider?.selectedCharacterId;
  }

  @override
  bool updateShouldNotify(SelectedCharacterIdProvider oldWidget) {
    return selectedCharacterId != oldWidget.selectedCharacterId;
  }
}
