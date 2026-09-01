import 'candidature.dart';

/// A directory entry a parent can browse and turn into a candidature.
///
/// The seed data shipped in [CrecheSeedData] is deliberately generic
/// (city/quartier-level, no invented street address or phone number) —
/// it's example data to validate the search UX, not a verified listing.
class CrecheListing {
  const CrecheListing({
    required this.nom,
    required this.type,
    required this.ville,
    required this.quartier,
  });

  final String nom;
  final ModeGardeType type;
  final String ville;
  final String quartier;
}
