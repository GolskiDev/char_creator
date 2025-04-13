import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'models/character_5e_class_model_v1.dart';
import 'models/character_5e_class_state_model_v1.dart';
import 'models/character_5e_model_v1.dart';
import 'repository/character_repository.dart';
import 'widgets/character_classes_widget.dart';

class EditCharacter5ePage extends HookConsumerWidget {
  final String? characterId;

  const EditCharacter5ePage({
    super.key,
    this.characterId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(charactersStreamProvider);

    final Character5eModelV1? character;
    switch (charactersAsync) {
      case AsyncValue(value: final List<Character5eModelV1> characters):
        final foundCharacter = characters
            .firstWhereOrNull((character) => character.id == characterId);
        character = foundCharacter;
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text('Character'),
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }

    final _formKey = GlobalKey<FormState>();
    final isNewCharacter = character == null;

    final nameController = useTextEditingController(text: character?.name);
    final selectedClasses = useState<Set<ICharacter5eClassModelV1>>(
      character?.classesStates
              .map((classState) => classState.classModel)
              .toSet() ??
          const {},
    );

    save() async {
      if (_formKey.currentState!.validate()) {
        final classes = selectedClasses.value.map((classModel) {
          return Character5eClassStateModelV1.empty(
            classModel: classModel,
            classLevel: 1,
          );
        }).toSet();

        if (isNewCharacter) {
          final newCharacter = Character5eModelV1.empty(
            name: nameController.text,
            classes: classes,
          );
          await ref
              .read(characterRepositoryProvider)
              .saveCharacter(newCharacter);
        } else {
          final updatedCharacter = character!.copyWith(
            name: nameController.text,
            classesStates: classes,
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
              Text('Classes'),
              CharacterClassesWidget.editing(
                selectedClasses: selectedClasses.value,
                onSelectionChanged: (updatedSelection) {
                  selectedClasses.value = updatedSelection;
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
