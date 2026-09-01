import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/candidature.dart';
import '../models/child_profile.dart';

/// Local-only persistence layer. Everything stays on-device (Hive/IndexedDB
/// on web) — there is no backend, and no family data ever leaves the phone.
class StorageService {
  StorageService._();

  static const _candidaturesBox = 'candidatures';
  static const _checklistBox = 'checklist';
  static const _profileBox = 'profile';

  static const _uuid = Uuid();

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_candidaturesBox);
    await Hive.openBox(_checklistBox);
    await Hive.openBox(_profileBox);
  }

  // ---- Profil enfant ----

  static ChildProfile getProfile() {
    final box = Hive.box(_profileBox);
    final raw = box.get('child');
    if (raw == null) return ChildProfile();
    return ChildProfile.fromMap(Map<dynamic, dynamic>.from(raw as Map));
  }

  static Future<void> saveProfile(ChildProfile profile) async {
    final box = Hive.box(_profileBox);
    await box.put('child', profile.toMap());
  }

  static bool get hasCompletedOnboarding =>
      Hive.box(_profileBox).get('onboardingDone', defaultValue: false) as bool;

  static Future<void> markOnboardingDone() async {
    await Hive.box(_profileBox).put('onboardingDone', true);
  }

  // ---- Candidatures ----

  static List<Candidature> getCandidatures() {
    final box = Hive.box(_candidaturesBox);
    return box.values
        .map((raw) => Candidature.fromMap(Map<dynamic, dynamic>.from(raw as Map)))
        .toList();
  }

  static Future<Candidature> addCandidature({
    required String nom,
    required ModeGardeType type,
    String? contact,
    String? adresse,
    DateTime? dateLimiteDossier,
    DateTime? dateRentreeSouhaitee,
    DateTime? dateRelance,
    String? notes,
  }) async {
    final candidature = Candidature(
      id: _uuid.v4(),
      nom: nom,
      type: type,
      contact: contact,
      adresse: adresse,
      dateLimiteDossier: dateLimiteDossier,
      dateRentreeSouhaitee: dateRentreeSouhaitee,
      dateRelance: dateRelance,
      notes: notes,
    );
    await Hive.box(_candidaturesBox).put(candidature.id, candidature.toMap());
    return candidature;
  }

  static Future<void> updateCandidature(Candidature candidature) async {
    await Hive.box(_candidaturesBox)
        .put(candidature.id, candidature.toMap());
  }

  static Future<void> deleteCandidature(String id) async {
    await Hive.box(_candidaturesBox).delete(id);
  }

  // ---- Checklist documents ----

  static const defaultChecklistItems = [
    'Avis d\'imposition (n-2)',
    'Justificatif de domicile',
    'Copie des pièces d\'identité des parents',
    'Livret de famille ou acte de naissance',
    'Attestation CAF / n° allocataire',
    'Attestations employeur des deux parents',
    'Carnet de santé / carnet de vaccination',
    'RIB',
  ];

  static Map<String, bool> getChecklistState() {
    final box = Hive.box(_checklistBox);
    return {
      for (final item in defaultChecklistItems)
        item: box.get(item, defaultValue: false) as bool,
    };
  }

  static Future<void> setChecklistItem(String item, bool checked) async {
    await Hive.box(_checklistBox).put(item, checked);
  }
}
