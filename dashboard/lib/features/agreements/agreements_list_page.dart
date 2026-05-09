import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'agreement_model.dart';
import 'agreements_repository.dart';

class AgreementsListPage extends ConsumerWidget {
  // List of available actions for debug and prod
  static const List<String> debugActions = [
    'Delete agreement (Terms of Use/Privacy Policy)',
  ];
  static const List<String> prodActions = [
    'Add agreement (Terms of Use/Privacy Policy)',
  ];

  const AgreementsListPage({super.key});

  static Widget buildAgreementList(
    String title,
    List<AgreementModel> agreements, {
    AgreementType? type,
    WidgetRef? ref,
  }) {
    if (agreements.isEmpty) {
      return Center(child: Text('No $title agreements found.'));
    }
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: agreements.length,
              itemBuilder: (context, index) {
                final agreement = agreements[index];
                return ListTile(
                  title: Text('Version: ${agreement.version}'),
                  subtitle: Text(
                    'Effective: ${agreement.effectiveDate.toDate()}',
                  ),
                  trailing: _AgreementDeleteAction(
                    agreement: agreement,
                    type: type,
                    ref: ref,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsAsync = ref.watch(agreementsProvider(AgreementType.termsOfUse));
    final privacyAsync = ref.watch(
      agreementsProvider(AgreementType.privacyPolicy),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Agreements Lists')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: termsAsync.when(
                data: (agreements) => AgreementsListPage.buildAgreementList(
                  'Terms of Use',
                  agreements,
                  type: AgreementType.termsOfUse,
                  ref: ref,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: privacyAsync.when(
                data: (agreements) => AgreementsListPage.buildAgreementList(
                  'Privacy Policies',
                  agreements,
                  type: AgreementType.privacyPolicy,
                  ref: ref,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const _AddAgreementFab(),
    );
  }
}

class _AgreementDeleteAction extends StatelessWidget {
  final AgreementModel agreement;
  final AgreementType? type;
  final WidgetRef? ref;

  const _AgreementDeleteAction({required this.agreement, this.type, this.ref});

  @override
  Widget build(BuildContext context) {
    final agreementType = type;
    final widgetRef = ref;
    if (!kDebugMode || agreementType == null || widgetRef == null) {
      return const SizedBox.shrink();
    }
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      tooltip: 'Delete',
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Agreement'),
            content: Text(
              'Are you sure you want to delete version "${agreement.version}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          await widgetRef
              .read(agreementsRepositoryProvider)
              .deleteAgreement(agreementType, agreement.version);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Agreement ${agreement.version} deleted.')),
          );
        }
      },
    );
  }
}

@override
Widget build(BuildContext context, WidgetRef ref) {
  final termsAsync = ref.watch(agreementsProvider(AgreementType.termsOfUse));
  final privacyAsync = ref.watch(
    agreementsProvider(AgreementType.privacyPolicy),
  );

  return Scaffold(
    appBar: AppBar(title: const Text('Agreements Lists')),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: termsAsync.when(
              data: (agreements) => AgreementsListPage.buildAgreementList(
                'Terms of Use',
                agreements,
                type: AgreementType.termsOfUse,
                ref: ref,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: privacyAsync.when(
              data: (agreements) => AgreementsListPage.buildAgreementList(
                'Privacy Policies',
                agreements,
                type: AgreementType.privacyPolicy,
                ref: ref,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: const _AddAgreementFab(),
  );
}

class DebugProdActionsList extends StatelessWidget {
  const DebugProdActionsList({super.key});

  @override
  Widget build(BuildContext context) {
    final debugActions = <Widget>[];
    final prodActions = <Widget>[];
    // Add actions for debug
    if (kDebugMode) {
      debugActions.add(
        const ListTile(
          leading: Icon(Icons.delete, color: Colors.red),
          title: Text('Delete agreement'),
          subtitle: Text('Delete Terms of Use or Privacy Policy agreement'),
        ),
      );
    }
    // Add actions for prod (always available)
    prodActions.add(
      const ListTile(
        leading: Icon(Icons.add),
        title: Text('Add agreement'),
        subtitle: Text('Add Terms of Use or Privacy Policy agreement'),
      ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Actions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (prodActions.isNotEmpty) ...[
              const SizedBox(height: 4),
              const Text('Production:'),
              ...prodActions,
            ],
            if (debugActions.isNotEmpty) ...[
              const SizedBox(height: 4),
              const Text('Debug only:'),
              ...debugActions,
            ],
          ],
        ),
      ),
    );
  }
}

class _AddAgreementFab extends ConsumerWidget {
  const _AddAgreementFab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => _showAddAgreementDialog(context, ref),
      tooltip: 'Add Agreement',
      child: const Icon(Icons.add),
    );
  }

  void _showAddAgreementDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    AgreementType? selectedType = AgreementType.termsOfUse;
    final versionController = TextEditingController();
    final linkController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Agreement'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 8.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<AgreementType>(
                          initialValue: selectedType,
                          items: const [
                            DropdownMenuItem(
                              value: AgreementType.termsOfUse,
                              child: Text('Terms of Use'),
                            ),
                            DropdownMenuItem(
                              value: AgreementType.privacyPolicy,
                              child: Text('Privacy Policy'),
                            ),
                          ],
                          onChanged: (val) =>
                              setState(() => selectedType = val),
                          decoration: const InputDecoration(labelText: 'Type'),
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: versionController,
                          decoration: const InputDecoration(
                            labelText: 'Version',
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter version' : null,
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: linkController,
                          decoration: const InputDecoration(
                            labelText: 'Link (en)',
                          ),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter link' : null,
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Effective Date: \\${selectedDate.toLocal().toString().split(' ')[0]}',
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() => selectedDate = picked);
                                }
                              },
                              child: const Text('Pick Date'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final type = selectedType;
                    if (type != null && (formKey.currentState?.validate() ?? false)) {
                      final repo = ref.read(agreementsRepositoryProvider);
                      await repo.addAgreement(
                        AgreementModel(
                          type: type,
                          effectiveDate: Timestamp.fromDate(selectedDate),
                          version: versionController.text.trim(),
                          extra: {'link_en': linkController.text.trim()},
                        ),
                      );
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Agreement added!')),
                      );
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
