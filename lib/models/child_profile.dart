class ChildProfile {
  ChildProfile({
    this.prenom,
    this.dateNaissance,
    this.zone,
  });

  String? prenom;
  DateTime? dateNaissance;
  String? zone;

  bool get isComplete =>
      (prenom?.isNotEmpty ?? false) && (zone?.isNotEmpty ?? false);

  Map<String, dynamic> toMap() => {
        'prenom': prenom,
        'dateNaissance': dateNaissance?.toIso8601String(),
        'zone': zone,
      };

  static ChildProfile fromMap(Map<dynamic, dynamic> map) => ChildProfile(
        prenom: map['prenom'] as String?,
        dateNaissance: map['dateNaissance'] == null
            ? null
            : DateTime.tryParse(map['dateNaissance'] as String),
        zone: map['zone'] as String?,
      );
}
