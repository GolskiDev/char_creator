import 'package:flutter/material.dart';

import 'agreements/mobile_agreements_page.dart';
import 'spell_texts/mobile_spell_texts_page.dart';
import 'updates/mobile_updates_page.dart';

class MobileAppShell extends StatefulWidget {
  const MobileAppShell({super.key});

  @override
  State<MobileAppShell> createState() => _MobileAppShellState();
}

class _MobileAppShellState extends State<MobileAppShell> {
  int _selectedIndex = 0;

  static const _labels = ['Agreements', 'App Versions', 'Spell Texts'];
  static const _icons = [
    Icons.description,
    Icons.system_update,
    Icons.auto_awesome,
  ];
  static final _pages = [
    const MobileAgreementsPage(),
    const MobileAppVersionsPage(),
    const MobileSpellTextsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_labels[_selectedIndex])),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: List.generate(
          _labels.length,
          (i) => NavigationDestination(
            icon: Icon(_icons[i]),
            label: _labels[i],
          ),
        ),
      ),
    );
  }
}
