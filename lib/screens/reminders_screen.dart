import 'package:flutter/material.dart';

import '../models/candidature.dart';
import '../services/storage_service.dart';
import '../widgets/status_chip.dart';
import 'candidature_detail_screen.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => RemindersScreenState();
}

class RemindersScreenState extends State<RemindersScreen> {
  List<Candidature> _withDeadline = [];

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    final all = StorageService.getCandidatures()
        .where((c) => c.prochaineEcheance != null)
        .toList()
      ..sort((a, b) => a.prochaineEcheance!.compareTo(b.prochaineEcheance!));
    setState(() => _withDeadline = all);
  }

  Future<void> _openDetail(Candidature candidature) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CandidatureDetailScreen(candidature: candidature),
      ),
    );
    if (changed == true) refresh();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final enRetard =
        _withDeadline.where((c) => c.prochaineEcheance!.isBefore(todayOnly)).toList();
    final aVenir =
        _withDeadline.where((c) => !c.prochaineEcheance!.isBefore(todayOnly)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Rappels')),
      body: _withDeadline.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications_none_rounded,
                        size: 56, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune échéance pour l\'instant',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ajoute une date limite ou une relance sur une candidature pour la voir apparaître ici.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                if (enRetard.isNotEmpty) ...[
                  _SectionHeader(
                    label: 'En retard',
                    color: Theme.of(context).colorScheme.error,
                  ),
                  ...enRetard.map((c) => _ReminderTile(
                        candidature: c,
                        onTap: () => _openDetail(c),
                      )),
                  const SizedBox(height: 16),
                ],
                if (aVenir.isNotEmpty) ...[
                  _SectionHeader(
                    label: 'À venir',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  ...aVenir.map((c) => _ReminderTile(
                        candidature: c,
                        onTap: () => _openDetail(c),
                      )),
                ],
              ],
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.candidature, required this.onTap});

  final Candidature candidature;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date = candidature.prochaineEcheance!;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(candidature.nom,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('Échéance : ${date.day}/${date.month}/${date.year}'),
        trailing: StatusChip(status: candidature.status),
      ),
    );
  }
}
