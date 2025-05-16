import '../../data/dto/breed_dto.dart';

class Breed {
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

  Breed({
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

  factory Breed.fromDTO(BreedDTO dto) {
    return Breed(
      id: dto.id,
      name: dto.name,
      weight: dto.weight,
      cfaUrl: dto.cfaUrl,
      vetstreetUrl: dto.vetstreetUrl,
      vcahospitalsUrl: dto.vcahospitalsUrl,
      temperament: dto.temperament,
      origin: dto.origin,
      countryCode: dto.countryCode,
      description: dto.description,
      lifeSpan: dto.lifeSpan,
      indoor: dto.indoor,
      altNames: dto.altNames,
      adaptability: dto.adaptability,
      affectionLevel: dto.affectionLevel,
      childFriendly: dto.childFriendly,
      dogFriendly: dto.dogFriendly,
      energyLevel: dto.energyLevel,
      grooming: dto.grooming,
      healthIssues: dto.healthIssues,
      intelligence: dto.intelligence,
      sheddingLevel: dto.sheddingLevel,
      socialNeeds: dto.socialNeeds,
      strangerFriendly: dto.strangerFriendly,
      vocalisation: dto.vocalisation,
      experimental: dto.experimental,
      hairless: dto.hairless,
      natural: dto.natural,
      rare: dto.rare,
      rex: dto.rex,
      suppressedTail: dto.suppressedTail,
      shortLegs: dto.shortLegs,
      wikipediaUrl: dto.wikipediaUrl,
      hypoallergenic: dto.hypoallergenic,
      referenceImageId: dto.referenceImageId,
    );
  }
}
