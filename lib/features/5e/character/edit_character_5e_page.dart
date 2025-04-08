import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'models/character_5e_model_v1.dart';
import 'repository/character_repository.dart';

class EditCharacter5ePage extends HookConsumerWidget {
  final Character5eModelV1? character;

  const EditCharacter5ePage({
    super.key,
    this.character,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final isNewCharacter = character == null;

    final nameController = useTextEditingController(text: character?.name);

    save() async {
      if (_formKey.currentState!.validate()) {
        if (isNewCharacter) {
          final newCharacter = Character5eModelV1.empty(
            name: nameController.text,
          );
          await ref
              .read(characterRepositoryProvider)
              .saveCharacter(newCharacter);
        } else {
          final updatedCharacter = character!.copyWith(
            name: nameController.text,
          );
          await ref
              .read(characterRepositoryProvider)
              .updateCharacter(updatedCharacter);
        }
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isNewCharacter ? 'Create Character' : 'Edit Character'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: save,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
