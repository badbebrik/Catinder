class BreedDTO {
  final String id;
  final String name;
  final String? weight;
  final String? cfaUrl;
  final String? vetstreetUrl;
  final String? vcahospitalsUrl;
  final String? temperament;
  final String? origin;
  final String? countryCode;
  final String? description;
  final String? lifeSpan;
  final int? indoor;
  final String? altNames;
  final int? adaptability;
  final int? affectionLevel;
  final int? childFriendly;
  final int? dogFriendly;
  final int? energyLevel;
  final int? grooming;
  final int? healthIssues;
  final int? intelligence;
  final int? sheddingLevel;
  final int? socialNeeds;
  final int? strangerFriendly;
  final int? vocalisation;
  final int? experimental;
  final int? hairless;
  final int? natural;
  final int? rare;
  final int? rex;
  final int? suppressedTail;
  final int? shortLegs;
  final String? wikipediaUrl;
  final int? hypoallergenic;
  final String? referenceImageId;

  BreedDTO({
    required this.id,
    required this.name,
    this.weight,
    this.cfaUrl,
    this.vetstreetUrl,
    this.vcahospitalsUrl,
    this.temperament,
    this.origin,
    this.countryCode,
    this.description,
    this.lifeSpan,
    this.indoor,
    this.altNames,
    this.adaptability,
    this.affectionLevel,
    this.childFriendly,
    this.dogFriendly,
    this.energyLevel,
    this.grooming,
    this.healthIssues,
    this.intelligence,
    this.sheddingLevel,
    this.socialNeeds,
    this.strangerFriendly,
    this.vocalisation,
    this.experimental,
    this.hairless,
    this.natural,
    this.rare,
    this.rex,
    this.suppressedTail,
    this.shortLegs,
    this.wikipediaUrl,
    this.hypoallergenic,
    this.referenceImageId,
  });

  factory BreedDTO.fromJson(Map<String, dynamic> json) {
    final weightData = json['weight'] as Map<String, dynamic>;
    return BreedDTO(
      id: json['id'] as String,
      name: json['name'] as String,
      weight: weightData['metric'] as String?,
      cfaUrl: json['cfa_url'] as String?,
      vetstreetUrl: json['vetstreet_url'] as String?,
      vcahospitalsUrl: json['vcahospitals_url'] as String?,
      temperament: json['temperament'] as String?,
      origin: json['origin'] as String?,
      countryCode: json['country_code'] as String?,
      description: json['description'] as String?,
      lifeSpan: json['life_span'] as String?,
      indoor: json['indoor'] as int?,
      altNames: json['alt_names'] as String?,
      adaptability: json['adaptability'] as int?,
      affectionLevel: json['affection_level'] as int?,
      childFriendly: json['child_friendly'] as int?,
      dogFriendly: json['dog_friendly'] as int?,
      energyLevel: json['energy_level'] as int?,
      grooming: json['grooming'] as int?,
      healthIssues: json['health_issues'] as int?,
      intelligence: json['intelligence'] as int?,
      sheddingLevel: json['shedding_level'] as int?,
      socialNeeds: json['social_needs'] as int?,
      strangerFriendly: json['stranger_friendly'] as int?,
      vocalisation: json['vocalisation'] as int?,
      experimental: json['experimental'] as int?,
      hairless: json['hairless'] as int?,
      natural: json['natural'] as int?,
      rare: json['rare'] as int?,
      rex: json['rex'] as int?,
      suppressedTail: json['suppressed_tail'] as int?,
      shortLegs: json['short_legs'] as int?,
      wikipediaUrl: json['wikipedia_url'] as String?,
      hypoallergenic: json['hypoallergenic'] as int?,
      referenceImageId: json['reference_image_id'] as String?,
    );
  }
}
