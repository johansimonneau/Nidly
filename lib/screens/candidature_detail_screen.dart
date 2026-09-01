import 'package:flutter/material.dart';

import '../models/candidature.dart';
import '../services/storage_service.dart';
import '../widgets/status_chip.dart';
import 'candidature_form_screen.dart';

class CandidatureDetailScreen extends StatefulWidget {
  const CandidatureDetailScreen({super.key, required this.candidature});

  final Candidature candidature;

  @override
  State<CandidatureDetailScreen> createState() =>
      _CandidatureDetailScreenState();
}

class _CandidatureDetailScreenState extends State<CandidatureDetailScreen> {
  late Candidature _candidature;

  @override
  void initState() {
    super.initState();
    _candidature = widget.candidature;
  }

  String _formatDate(DateTime? date) =>
      date == null ? 'Non définie' : '${date.day}/${date.month}/${date.year}';

  Future<void> _edit() async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CandidatureFormScreen(candidature: _candidature),
      ),
    );
    if (changed == true && mounted) {
      setState(() {}); // _candidature is mutated in place by the form.
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer cette candidature ?'),
        content: Text('« ${_candidature.nom} » sera définitivement supprimée.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await StorageService.deleteCandidature(_candidature.id);
      if (mounted) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_candidature.nom),
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: _edit),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _delete,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Text(
                _candidature.type.label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              StatusChip(status: _candidature.status),
            ],
          ),
          const SizedBox(height: 16),
          if (_candidature.contact != null)
            _InfoRow(icon: Icons.call_outlined, label: _candidature.contact!),
          if (_candidature.adresse != null)
            _InfoRow(
              icon: Icons.place_outlined,
              label: _candidature.adresse!,
            ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dates clés', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  _DateRow(
                    label: 'Date limite du dossier',
                    value: _formatDate(_candidature.dateLimiteDossier),
                  ),
                  _DateRow(
                    label: 'Rentrée souhaitée',
                    value: _formatDate(_candidature.dateRentreeSouhaitee),
                  ),
                  _DateRow(
                    label: 'Prochaine relance',
                    value: _formatDate(_candidature.dateRelance),
                  ),
                ],
              ),
            ),
          ),
          if (_candidature.notes != null && _candidature.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notes', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Text(_candidature.notes!),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
