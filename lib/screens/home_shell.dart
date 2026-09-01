import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'annuaire_screen.dart';
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
        return const AnnuaireScreen();
      case 2:
        return const RemindersScreen();
      case 3:
        return const ChecklistScreen();
      case 0:
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: _buildBody(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: NavigationBar(
              height: 68,
              selectedIndex: _index,
              onDestinationSelected: (value) => setState(() => _index = value),
              backgroundColor: Colors.transparent,
              elevation: 0,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.list_alt_outlined),
                  selectedIcon: Icon(Icons.list_alt),
                  label: 'Candidatures',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search_rounded),
                  selectedIcon: Icon(Icons.search_rounded),
                  label: 'Annuaire',
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
          ),
        ),
      ),
    );
  }
}
