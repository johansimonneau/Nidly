import 'package:flutter/material.dart';

import 'checklist_screen.dart';
import 'dashboard_screen.dart';
import 'reminders_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  // Rebuilding (rather than an IndexedStack) each time a tab is selected
  // keeps the screens' initState-driven Hive reads fresh with zero extra
  // plumbing — acceptable for this MVP's small, local-only dataset.
  Widget _buildBody() {
    switch (_index) {
      case 1:
        return const RemindersScreen();
      case 2:
        return const ChecklistScreen();
      case 0:
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Candidatures',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Rappels',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Checklist',
          ),
        ],
      ),
    );
  }
}
