import 'package:flutter/material.dart';

import 'agreements/web_agreements_page.dart';
import 'spell_texts/web_spell_texts_page.dart';
import 'updates/web_updates_page.dart';

class WebAppShell extends StatefulWidget {
  const WebAppShell({super.key});

  @override
  State<WebAppShell> createState() => _WebAppShellState();
}

class _WebAppShellState extends State<WebAppShell> {
  int _selectedIndex = 0;

  static final List<_NavItem> _navItems = [
    _NavItem('Agreements', Icons.description, const WebAgreementsPage()),
    _NavItem('App Versions', Icons.system_update, const WebAppVersionsPage()),
    _NavItem('Spell Texts', Icons.auto_awesome, const WebSpellTextsPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            labelType: NavigationRailLabelType.all,
            destinations: _navItems
                .map((item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      label: Text(item.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _navItems[_selectedIndex].child),
        ],
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final Widget child;
  const _NavItem(this.label, this.icon, this.child);
}
