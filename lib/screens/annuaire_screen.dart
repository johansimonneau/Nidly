import 'package:flutter/material.dart';

import '../data/creche_seed_data.dart';
import '../models/creche_listing.dart';
import '../theme/app_colors.dart';
import 'candidature_form_screen.dart';

class AnnuaireScreen extends StatefulWidget {
  const AnnuaireScreen({super.key});

  @override
  State<AnnuaireScreen> createState() => _AnnuaireScreenState();
}

class _AnnuaireScreenState extends State<AnnuaireScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CrecheListing> get _results {
    if (_query.trim().isEmpty) return const [];
    final q = _query.trim().toLowerCase();
    return CrecheSeedData.listings
        .where((l) => l.ville.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _addFromListing(CrecheListing listing) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CandidatureFormScreen(
          prefillNom: listing.nom,
          prefillType: listing.type,
          prefillAdresse: '${listing.quartier}, ${listing.ville}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Annuaire')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppColors.sunshine.withValues(alpha: 0.18),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppColors.ink),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Liste d\'exemple pour tester la recherche — à remplacer par un vrai annuaire local dès qu\'on branche une source de données.',
                        style: TextStyle(fontSize: 13, color: AppColors.ink),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Rechercher une ville',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_query.trim().isEmpty) {
      return _EmptyHint(
        icon: Icons.location_city_rounded,
        title: 'Cherche une ville',
        subtitle: 'Essaie Paris, Lyon, Marseille, Toulouse, Bordeaux...',
      );
    }
    if (_results.isEmpty) {
      return const _EmptyHint(
        icon: Icons.search_off_rounded,
        title: 'Aucun résultat',
        subtitle: 'Pas d\'exemple pour cette ville pour l\'instant.',
      );
    }
    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final listing = _results[index];
        return Card(
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(listing.nom,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('${listing.type.label} · ${listing.quartier}'),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.coral),
              onPressed: () => _addFromListing(listing),
              tooltip: 'Ajouter à mes candidatures',
            ),
          ),
        );
      },
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint(
      {required this.icon, required this.title, required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
