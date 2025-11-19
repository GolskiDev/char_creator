import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../5e/game_system_view_model.dart';
import 'user_preference_interface.dart';
import 'user_preferences_interactor.dart';

extension UserThemeMode on ThemeMode {
  GameSystemViewModelItem get _viewModel {
    switch (this) {
      case ThemeMode.light:
        return GameSystemViewModel.lightTheme;
      case ThemeMode.dark:
        return GameSystemViewModel.darkTheme;
      case ThemeMode.system:
        return GameSystemViewModel.systemTheme;
    }
  }

  IconData? get icon => _viewModel.icon;
  String get name => _viewModel.name;

  static ThemeMode? fromString(String? string) {
    return ThemeMode.values.firstWhereOrNull(
      (e) => e.toString() == string,
    );
  }
}

class UserThemePreference implements UserPreferenceInterface<ThemeMode?> {
  @override
  final ThemeMode? _value;

  ThemeMode get theme => _value ?? ThemeMode.system;

  const UserThemePreference(this._value);

  @override
  String get key => _key;
  static const _key = 'prefferred_theme';

  factory UserThemePreference.fromJson(Map<String, dynamic> json) {
    final themeMode = UserThemeMode.fromString(json[_key] as String?);
    return UserThemePreference(themeMode);
  }

  @override
  Map<String, dynamic> toJson() => {
        _key: _value?.toString(),
      };
}

/// Go ahead and create another FutureProvider for UserThemePreference
/// that awaits for the data from userPrefrencesProvider
final userThemePreferenceProvider = Provider<UserThemePreference>(
  (ref) {
    final userPreferences =
        ref.watch(userPrefrencesProvider).asData?.value ?? {};
    final userThemePreference = UserThemePreference.fromJson(userPreferences);
    return userThemePreference;
  },
);

class UserThemePreferenceWidget extends ConsumerWidget {
  const UserThemePreferenceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userThemePreference = ref.watch(userThemePreferenceProvider);
    return ListTile(
      title: const Text('Theme Preference'),
      trailing: DropdownButton<ThemeMode>(
        value: userThemePreference.theme,
        items: ThemeMode.values.map((ThemeMode value) {
          return DropdownMenuItem<ThemeMode>(
            value: value,
            child: Row(
              children: [
                if (value.icon != null) Icon(value.icon),
                const SizedBox(width: 8),
                Text(value.name),
              ],
            ),
          );
        }).toList(),
        onChanged: (ThemeMode? newValue) async {
          final userPreferencesInteractor =
              await ref.read(userPreferencesInteractorProvider.future);
          final newPreference = UserThemePreference(newValue);
          await userPreferencesInteractor.updatePreference(newPreference);
        },
      ),
    );
  }
}
