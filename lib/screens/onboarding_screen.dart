import 'package:flutter/material.dart';

import '../models/child_profile.dart';
import '../services/storage_service.dart';
import 'home_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prenomController = TextEditingController();
  final _zoneController = TextEditingController();
  DateTime? _dateNaissance;

  @override
  void dispose() {
    _prenomController.dispose();
    _zoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      helpText: 'Date de naissance (ou prévue)',
    );
    if (picked != null) setState(() => _dateNaissance = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final profile = ChildProfile(
      prenom: _prenomController.text.trim(),
      dateNaissance: _dateNaissance,
      zone: _zoneController.text.trim(),
    );
    await StorageService.saveProfile(profile);
    await StorageService.markOnboardingDone();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Icon(Icons.eco_rounded,
                    size: 48, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  'Bienvenue sur Nidly',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'On t\'aide à garder le fil de toutes tes candidatures crèche et assistante maternelle, sans rien perdre.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _prenomController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom de l\'enfant',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Ce champ est requis'
                      : null,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date de naissance (ou prévue)',
                    ),
                    child: Text(
                      _dateNaissance == null
                          ? 'Choisir une date'
                          : '${_dateNaissance!.day}/${_dateNaissance!.month}/${_dateNaissance!.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _zoneController,
                  decoration: const InputDecoration(
                    labelText: 'Ville / commune',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Ce champ est requis'
                      : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Text('Commencer'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
