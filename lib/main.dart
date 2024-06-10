import 'package:char_creator/features/basic_chat_support/chat_widget.dart';
import 'package:char_creator/features/character/character_data_source_provider.dart';
import 'package:char_creator/features/character/character_temp_data_source.dart';
import 'package:char_creator/features/styling/list_of_all_widgets.dart';
import 'package:char_creator/features/styling/main_theme.dart';
import 'package:flutter/material.dart';

import 'features/character/StreamBuilderWithState.dart';
import 'features/character/character.dart';
import 'features/character/character_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      home: CharacterDataSourceProvider(
        characterTempDataSource: CharacterTempDataSource(),
        child: Scaffold(
          body: PageViewWidget(),
        ),
      ),
    );
  }
}

class PageViewWidget extends StatefulWidget {
  const PageViewWidget({super.key});

  @override
  State<PageViewWidget> createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final characterStream = CharacterDataSourceProvider.of(context)
        ?.characterTempDataSource
        .getAllCharactersStream();
    return PageView(
      controller: _pageController,
      children: [
        if (characterStream != null) ...[
          StreamBuilderWithState<List<Character>>(
            stream: characterStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final character = snapshot.data?.first;
                if (character == null) {
                  return Center(child: const Text('No character found'));
                }
                return CharacterWidget(character: character);
              }
              return Center(child: const CircularProgressIndicator());
            },
          ),
        ],
        ChatWidget(),
      ],
    );
  }
}
