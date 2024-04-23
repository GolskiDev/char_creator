import 'prompt_model.dart';

class PromptDataSource {
  Future<List<PromptModel>> get({
    List<String> ids = const [],
  }) {
    return Future.value([
      PromptModel(
        prompt: 'What is your name?',
        id: '1',
      ),
      PromptModel(
        prompt: 'What is your favorite color?',
        id: '2',
      ),
      PromptModel(
        prompt: 'What is your favorite food?',
        id: '3',
      ),
    ]);
  }
}
