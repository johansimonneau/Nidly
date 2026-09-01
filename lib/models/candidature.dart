import 'candidature_status.dart';

enum ModeGardeType {
  crecheMunicipale,
  crechePrivee,
  microCreche,
  crecheAssociative,
  assistanteMaternelle,
  autre;

  String get label => switch (this) {
        ModeGardeType.crecheMunicipale => 'Crèche municipale',
        ModeGardeType.crechePrivee => 'Crèche privée',
        ModeGardeType.microCreche => 'Micro-crèche',
        ModeGardeType.crecheAssociative => 'Crèche associative',
        ModeGardeType.assistanteMaternelle => 'Assistante maternelle',
        ModeGardeType.autre => 'Autre',
      };

  static ModeGardeType fromName(String name) {
    return ModeGardeType.values.firstWhere(
      (t) => t.name == name,
      orElse: () => ModeGardeType.autre,
    );
  }
}

class Candidature {
  Candidature({
    required this.id,
    required this.nom,
    required this.type,
    this.status = CandidatureStatus.aContacter,
    this.contact,
    this.adresse,
    this.dateLimiteDossier,
    this.dateRentreeSouhaitee,
    this.dateRelance,
    this.notes,
  });

  final String id;
  String nom;
  ModeGardeType type;
  CandidatureStatus status;
  String? contact;
  String? adresse;
  DateTime? dateLimiteDossier;
  DateTime? dateRentreeSouhaitee;
  DateTime? dateRelance;
  String? notes;

  /// The closest upcoming (or overdue) date worth surfacing in reminders.
  DateTime? get prochaineEcheance {
    final dates = [dateLimiteDossier, dateRelance]
        .whereType<DateTime>()
        .toList()
      ..sort();
    return dates.isEmpty ? null : dates.first;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nom': nom,
        'type': type.name,
        'status': status.name,
        'contact': contact,
        'adresse': adresse,
        'dateLimiteDossier': dateLimiteDossier?.toIso8601String(),
        'dateRentreeSouhaitee': dateRentreeSouhaitee?.toIso8601String(),
        'dateRelance': dateRelance?.toIso8601String(),
        'notes': notes,
      };

  static Candidature fromMap(Map<dynamic, dynamic> map) {
    DateTime? parseDate(dynamic value) =>
        value == null ? null : DateTime.tryParse(value as String);

    return Candidature(
      id: map['id'] as String,
      nom: map['nom'] as String,
      type: ModeGardeType.fromName(map['type'] as String? ?? ''),
      status: CandidatureStatus.fromName(map['status'] as String? ?? ''),
      contact: map['contact'] as String?,
      adresse: map['adresse'] as String?,
      dateLimiteDossier: parseDate(map['dateLimiteDossier']),
      dateRentreeSouhaitee: parseDate(map['dateRentreeSouhaitee']),
      dateRelance: parseDate(map['dateRelance']),
      notes: map['notes'] as String?,
    );
  }
}
