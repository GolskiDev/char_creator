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
            // Always update controllers with latest Firestore data
            _controllers['latest_android'] ??= TextEditingController();
            _controllers['latest_ios'] ??= TextEditingController();
            _controllers['required_android'] ??= TextEditingController();
            _controllers['required_ios'] ??= TextEditingController();
            _controllers['latest_android']!.text = latest['android'] ?? '';
            _controllers['latest_ios']!.text = latest['ios'] ?? '';
            _controllers['required_android']!.text = required['android'] ?? '';
            _controllers['required_ios']!.text = required['ios'] ?? '';

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
                      controller: _controllers['latest_android'],
                      decoration: const InputDecoration(labelText: 'Android'),
                      validator: _versionValidator,
                    ),
                    TextFormField(
                      controller: _controllers['latest_ios'],
                      decoration: const InputDecoration(labelText: 'iOS'),
                      validator: _versionValidator,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Required Version',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _controllers['required_android'],
                      decoration: const InputDecoration(labelText: 'Android'),
                      validator: _versionValidator,
                    ),
                    TextFormField(
                      controller: _controllers['required_ios'],
                      decoration: const InputDecoration(labelText: 'iOS'),
                      validator: _versionValidator,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saving
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              setState(() => _saving = true);
                              // Only update changed fields
                              final latestUpdate = <String, dynamic>{};
                              final requiredUpdate = <String, dynamic>{};
                              if ((_controllers['latest_android']!.text.isEmpty
                                      ? null
                                      : _controllers['latest_android']!.text) !=
                                  (latest['android'] ?? null)) {
                                latestUpdate['android'] =
                                    _controllers['latest_android']!.text.isEmpty
                                    ? null
                                    : _controllers['latest_android']!.text;
                              }
                              if ((_controllers['latest_ios']!.text.isEmpty
                                      ? null
                                      : _controllers['latest_ios']!.text) !=
                                  (latest['ios'] ?? null)) {
                                latestUpdate['ios'] =
                                    _controllers['latest_ios']!.text.isEmpty
                                    ? null
                                    : _controllers['latest_ios']!.text;
                              }
                              if ((_controllers['required_android']!
                                          .text
                                          .isEmpty
                                      ? null
                                      : _controllers['required_android']!
                                            .text) !=
                                  (required['android'] ?? null)) {
                                requiredUpdate['android'] =
                                    _controllers['required_android']!
                                        .text
                                        .isEmpty
                                    ? null
                                    : _controllers['required_android']!.text;
                              }
                              if ((_controllers['required_ios']!.text.isEmpty
                                      ? null
                                      : _controllers['required_ios']!.text) !=
                                  (required['ios'] ?? null)) {
                                requiredUpdate['ios'] =
                                    _controllers['required_ios']!.text.isEmpty
                                    ? null
                                    : _controllers['required_ios']!.text;
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
