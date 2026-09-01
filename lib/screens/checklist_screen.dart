import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  late Map<String, bool> _state;

  @override
  void initState() {
    super.initState();
    _state = StorageService.getChecklistState();
  }

  int get _checkedCount => _state.values.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    final total = _state.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checklist documents'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.folder_copy_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Documents généralement demandés pour un dossier crèche ou assistante maternelle. Coche au fur et à mesure.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$_checkedCount / $total réunis',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ..._state.entries.map(
            (entry) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: CheckboxListTile(
                value: entry.value,
                title: Text(entry.key),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (checked) async {
                  final value = checked ?? false;
                  await StorageService.setChecklistItem(entry.key, value);
                  setState(() => _state[entry.key] = value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
