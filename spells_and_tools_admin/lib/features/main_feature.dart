import 'package:flutter/material.dart';

import 'agreements/agreements_list_page.dart';
import 'daily_texts/daily_texts_list_page.dart';
import 'updates/updates_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<_NavItem> _navItems = [
    _NavItem('Agreements', Icons.description, AgreementsListPage()),
    _NavItem('App Versions', Icons.system_update, AppVersionsPage()),
    _NavItem('Daily Texts', Icons.text_snippet, DailyTextsListPage()),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: _navItems
                .map(
                  (item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(item.label),
                  ),
                )
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
