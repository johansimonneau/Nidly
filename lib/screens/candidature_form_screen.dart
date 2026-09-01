import 'package:flutter/material.dart';

import '../models/candidature.dart';
import '../models/candidature_status.dart';
import '../services/storage_service.dart';

/// Add/edit form. Pass an existing [candidature] to edit it in place, or
/// omit it to create a new one — optionally pre-filled (e.g. from the
/// directory) via [prefillNom], [prefillType] and [prefillAdresse].
class CandidatureFormScreen extends StatefulWidget {
  const CandidatureFormScreen({
    super.key,
    this.candidature,
    this.prefillNom,
    this.prefillType,
    this.prefillAdresse,
  });

  final Candidature? candidature;
  final String? prefillNom;
  final ModeGardeType? prefillType;
  final String? prefillAdresse;

  @override
  State<CandidatureFormScreen> createState() => _CandidatureFormScreenState();
}

class _CandidatureFormScreenState extends State<CandidatureFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomController;
  late final TextEditingController _contactController;
  late final TextEditingController _adresseController;
  late final TextEditingController _notesController;
  late ModeGardeType _type;
  late CandidatureStatus _status;
  DateTime? _dateLimiteDossier;
  DateTime? _dateRentreeSouhaitee;
  DateTime? _dateRelance;

  bool get _isEditing => widget.candidature != null;

  @override
  void initState() {
    super.initState();
    final c = widget.candidature;
    _nomController =
        TextEditingController(text: c?.nom ?? widget.prefillNom ?? '');
    _contactController = TextEditingController(text: c?.contact ?? '');
    _adresseController = TextEditingController(
        text: c?.adresse ?? widget.prefillAdresse ?? '');
    _notesController = TextEditingController(text: c?.notes ?? '');
    _type = c?.type ?? widget.prefillType ?? ModeGardeType.crecheMunicipale;
    _status = c?.status ?? CandidatureStatus.aContacter;
    _dateLimiteDossier = c?.dateLimiteDossier;
    _dateRentreeSouhaitee = c?.dateRentreeSouhaitee;
    _dateRelance = c?.dateRelance;
  }

  @override
  void dispose() {
    _nomController.dispose();
    _contactController.dispose();
    _adresseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<DateTime?> _pickDate(DateTime? initial) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
  }

  String _formatDate(DateTime? date) =>
      date == null ? 'Non définie' : '${date.day}/${date.month}/${date.year}';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isEditing) {
      final c = widget.candidature!
        ..nom = _nomController.text.trim()
        ..type = _type
        ..status = _status
        ..contact = _contactController.text.trim().isEmpty
            ? null
            : _contactController.text.trim()
        ..adresse = _adresseController.text.trim().isEmpty
            ? null
            : _adresseController.text.trim()
        ..notes = _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim()
        ..dateLimiteDossier = _dateLimiteDossier
        ..dateRentreeSouhaitee = _dateRentreeSouhaitee
        ..dateRelance = _dateRelance;
      await StorageService.updateCandidature(c);
    } else {
      await StorageService.addCandidature(
        nom: _nomController.text.trim(),
        type: _type,
        contact: _contactController.text.trim().isEmpty
            ? null
            : _contactController.text.trim(),
        adresse: _adresseController.text.trim().isEmpty
            ? null
            : _adresseController.text.trim(),
        dateLimiteDossier: _dateLimiteDossier,
        dateRentreeSouhaitee: _dateRentreeSouhaitee,
        dateRelance: _dateRelance,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier la candidature' : 'Nouvelle candidature'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom de l\'établissement'),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Requis' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<ModeGardeType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Type de mode de garde'),
              items: ModeGardeType.values
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                  .toList(),
              onChanged: (value) => setState(() => _type = value!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CandidatureStatus>(
              initialValue: _status,
              decoration: const InputDecoration(labelText: 'Statut'),
              items: CandidatureStatus.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                  .toList(),
              onChanged: (value) => setState(() => _status = value!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactController,
              decoration: const InputDecoration(labelText: 'Contact (téléphone/email)'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _adresseController,
              decoration: const InputDecoration(labelText: 'Adresse'),
            ),
            const SizedBox(height: 24),
            Text('Dates clés', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _DateTile(
              label: 'Date limite du dossier',
              value: _dateLimiteDossier,
              formatDate: _formatDate,
              onPick: () async {
                final picked = await _pickDate(_dateLimiteDossier);
                if (picked != null) setState(() => _dateLimiteDossier = picked);
              },
              onClear: () => setState(() => _dateLimiteDossier = null),
            ),
            _DateTile(
              label: 'Date de rentrée souhaitée',
              value: _dateRentreeSouhaitee,
              formatDate: _formatDate,
              onPick: () async {
                final picked = await _pickDate(_dateRentreeSouhaitee);
                if (picked != null) setState(() => _dateRentreeSouhaitee = picked);
              },
              onClear: () => setState(() => _dateRentreeSouhaitee = null),
            ),
            _DateTile(
              label: 'Prochaine relance',
              value: _dateRelance,
              formatDate: _formatDate,
              onPick: () async {
                final picked = await _pickDate(_dateRelance);
                if (picked != null) setState(() => _dateRelance = picked);
              },
              onClear: () => setState(() => _dateRelance = null),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(_isEditing ? 'Enregistrer' : 'Ajouter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.value,
    required this.formatDate,
    required this.onPick,
    required this.onClear,
  });

  final String label;
  final DateTime? value;
  final String Function(DateTime?) formatDate;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onPick,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: value == null
                ? null
                : IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: onClear,
                  ),
          ),
          child: Text(formatDate(value)),
        ),
      ),
    );
  }
}
