import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

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
        CandidatureStatus.aContacter => AppColors.sand,
        CandidatureStatus.dossierEnvoye => AppColors.teal,
        CandidatureStatus.enAttente => AppColors.sunshine,
        CandidatureStatus.entretien => AppColors.plum,
        CandidatureStatus.accepte => AppColors.green,
        CandidatureStatus.refuse => AppColors.red,
      };
}
