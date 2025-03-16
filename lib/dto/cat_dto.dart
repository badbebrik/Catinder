import 'package:catinder/dto/breed_dto.dart';

class CatDTO {
  final String id;
  final String imageURL;
  final int width;
  final int height;
  final String? mimeType;
  final List<BreedDTO>? breeds;

  CatDTO({
    required this.id,
    required this.imageURL,
    required this.width,
    required this.height,
    this.mimeType,
    this.breeds,
  });

  factory CatDTO.fromJson(Map<String, dynamic> json) {
    return CatDTO(
        id: json['id'] as String,
        imageURL: json['url'] as String,
        width: json['width'] as int,
        height: json['height'] as int,
        mimeType: json['mime_type'] as String?,
        breeds: json['breeds'] != null
            ? (json['breeds'] as List).map((e) => BreedDTO.fromJson(e)).toList()
            : null);
  }
}
