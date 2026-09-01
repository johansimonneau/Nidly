import 'package:flutter/material.dart';

enum CandidatureStatus {
  aContacter,
  dossierEnvoye,
  enAttente,
  entretien,
  accepte,
  refuse;

  static CandidatureStatus fromName(String name) {
    return CandidatureStatus.values.firstWhere(
      (status) => status.name == name,
      orElse: () => CandidatureStatus.aContacter,
    );
  }

  String get label => switch (this) {
        CandidatureStatus.aContacter => 'À contacter',
        CandidatureStatus.dossierEnvoye => 'Dossier envoyé',
        CandidatureStatus.enAttente => 'En attente',
        CandidatureStatus.entretien => 'Entretien prévu',
        CandidatureStatus.accepte => 'Accepté',
        CandidatureStatus.refuse => 'Refusé',
      };

  Color get color => switch (this) {
        CandidatureStatus.aContacter => const Color(0xFF9E9E9E),
        CandidatureStatus.dossierEnvoye => const Color(0xFF5C9EAD),
        CandidatureStatus.enAttente => const Color(0xFFE8A23D),
        CandidatureStatus.entretien => const Color(0xFF7C6FD1),
        CandidatureStatus.accepte => const Color(0xFF4CAF7D),
        CandidatureStatus.refuse => const Color(0xFFD16E6E),
      };
}
