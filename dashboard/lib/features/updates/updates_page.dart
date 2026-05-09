import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'updates_repository.dart';

class AppVersionsPage extends ConsumerStatefulWidget {
  const AppVersionsPage({super.key});

  @override
  ConsumerState<AppVersionsPage> createState() => _AppVersionsPageState();
}

class _AppVersionsPageState extends ConsumerState<AppVersionsPage> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = <String, TextEditingController>{};
  bool _saving = false;

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  String? _versionValidator(String? value) {
    if (value == null || value.isEmpty) return null;
    final regex = RegExp(r'^\d+\.\d+\.\d+$');
    if (!regex.hasMatch(value)) {
      return 'Format: 999.999.999';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(appVersionsRepositoryProvider);
    final latestAsync = ref.watch(appVersionProvider('latest_version'));
    final requiredAsync = ref.watch(appVersionProvider('required_version'));

    return Scaffold(
      appBar: AppBar(title: const Text('App Versions Admin')),
      body: latestAsync.when(
        data: (latest) => requiredAsync.when(
          data: (required) {
            final latestAndroid =
                _controllers['latest_android'] ??= TextEditingController();
            final latestIos =
                _controllers['latest_ios'] ??= TextEditingController();
            final requiredAndroid =
                _controllers['required_android'] ??= TextEditingController();
            final requiredIos =
                _controllers['required_ios'] ??= TextEditingController();
            latestAndroid.text = latest['android'] ?? '';
            latestIos.text = latest['ios'] ?? '';
            requiredAndroid.text = required['android'] ?? '';
            requiredIos.text = required['ios'] ?? '';

            String? orNull(String text) => text.isEmpty ? null : text;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const Text(
                      'Latest Version',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: latestAndroid,
                      decoration: const InputDecoration(labelText: 'Android'),
                      validator: _versionValidator,
                    ),
                    TextFormField(
                      controller: latestIos,
                      decoration: const InputDecoration(labelText: 'iOS'),
                      validator: _versionValidator,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Required Version',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: requiredAndroid,
                      decoration: const InputDecoration(labelText: 'Android'),
                      validator: _versionValidator,
                    ),
                    TextFormField(
                      controller: requiredIos,
                      decoration: const InputDecoration(labelText: 'iOS'),
                      validator: _versionValidator,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saving
                          ? null
                          : () async {
                              if (!(_formKey.currentState?.validate() ?? false)) return;
                              setState(() => _saving = true);
                              final latestUpdate = <String, dynamic>{};
                              final requiredUpdate = <String, dynamic>{};
                              if (orNull(latestAndroid.text) != latest['android']) {
                                latestUpdate['android'] = orNull(latestAndroid.text);
                              }
                              if (orNull(latestIos.text) != latest['ios']) {
                                latestUpdate['ios'] = orNull(latestIos.text);
                              }
                              if (orNull(requiredAndroid.text) != required['android']) {
                                requiredUpdate['android'] = orNull(requiredAndroid.text);
                              }
                              if (orNull(requiredIos.text) != required['ios']) {
                                requiredUpdate['ios'] = orNull(requiredIos.text);
                              }
                              if (latestUpdate.isNotEmpty) {
                                await repo.setVersionDoc(
                                  'latest_version',
                                  latestUpdate,
                                );
                              }
                              if (requiredUpdate.isNotEmpty) {
                                await repo.setVersionDoc(
                                  'required_version',
                                  requiredUpdate,
                                );
                              }
                              setState(() => _saving = false);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Versions updated!'),
                                  ),
                                );
                              }
                            },
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save'),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
