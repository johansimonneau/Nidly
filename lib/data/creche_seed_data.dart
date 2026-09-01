import '../models/candidature.dart';
import '../models/creche_listing.dart';

/// Example directory entries for a handful of major French cities, used to
/// validate the search-by-city UX before a real open-data source (e.g.
/// data.gouv.fr) is wired in. Deliberately generic — quartier-level, no
/// fabricated address or phone number presented as fact.
class CrecheSeedData {
  CrecheSeedData._();

  static const List<CrecheListing> listings = [
    CrecheListing(
      nom: 'Crèche municipale — 11e arrondissement',
      type: ModeGardeType.crecheMunicipale,
      ville: 'Paris',
      quartier: '11e arrondissement',
    ),
    CrecheListing(
      nom: 'Micro-crèche associative — Belleville',
      type: ModeGardeType.microCreche,
      ville: 'Paris',
      quartier: 'Belleville',
    ),
    CrecheListing(
      nom: 'Crèche collective privée — Batignolles',
      type: ModeGardeType.crechePrivee,
      ville: 'Paris',
      quartier: 'Batignolles',
    ),
    CrecheListing(
      nom: 'Crèche municipale — Croix-Rousse',
      type: ModeGardeType.crecheMunicipale,
      ville: 'Lyon',
      quartier: 'Croix-Rousse',
    ),
    CrecheListing(
      nom: 'Micro-crèche associative — Guillotière',
      type: ModeGardeType.microCreche,
      ville: 'Lyon',
      quartier: 'Guillotière',
    ),
    CrecheListing(
      nom: 'Crèche municipale — Vieux-Port',
      type: ModeGardeType.crecheMunicipale,
      ville: 'Marseille',
      quartier: 'Vieux-Port',
    ),
    CrecheListing(
      nom: 'Crèche associative — Castellane',
      type: ModeGardeType.crecheAssociative,
      ville: 'Marseille',
      quartier: 'Castellane',
    ),
    CrecheListing(
      nom: 'Crèche municipale — Capitole',
      type: ModeGardeType.crecheMunicipale,
      ville: 'Toulouse',
      quartier: 'Capitole',
    ),
    CrecheListing(
      nom: 'Micro-crèche privée — Saint-Cyprien',
      type: ModeGardeType.microCreche,
      ville: 'Toulouse',
      quartier: 'Saint-Cyprien',
    ),
    CrecheListing(
      nom: 'Crèche municipale — Chartrons',
      type: ModeGardeType.crecheMunicipale,
      ville: 'Bordeaux',
      quartier: 'Chartrons',
    ),
    CrecheListing(
      nom: 'Crèche associative — Saint-Michel',
      type: ModeGardeType.crecheAssociative,
      ville: 'Bordeaux',
      quartier: 'Saint-Michel',
    ),
    CrecheListing(
      nom: 'Crèche municipale — Vieux-Lille',
      type: ModeGardeType.crecheMunicipale,
      ville: 'Lille',
      quartier: 'Vieux-Lille',
    ),
    CrecheListing(
      nom: 'Crèche municipale — Île de Nantes',
      type: ModeGardeType.crecheMunicipale,
      ville: 'Nantes',
      quartier: 'Île de Nantes',
    ),
    CrecheListing(
      nom: 'Micro-crèche privée — Hauts-Pavés',
      type: ModeGardeType.microCreche,
      ville: 'Nantes',
      quartier: 'Hauts-Pavés',
    ),
    CrecheListing(
      nom: 'Crèche municipale — Vieux-Nice',
      type: ModeGardeType.crecheMunicipale,
      ville: 'Nice',
      quartier: 'Vieux-Nice',
    ),
    CrecheListing(
      nom: 'Crèche municipale — Neudorf',
      type: ModeGardeType.crecheMunicipale,
      ville: 'Strasbourg',
      quartier: 'Neudorf',
    ),
    CrecheListing(
      nom: 'Crèche associative — Cité Judaïque',
      type: ModeGardeType.crecheAssociative,
      ville: 'Rennes',
      quartier: 'Cité Judaïque',
    ),
  ];
}
