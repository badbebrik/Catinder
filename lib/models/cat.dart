import '../dto/cat_dto.dart';
import 'breed.dart';

class Cat {
  final String id;
  final String imageUrl;
  final int width;
  final int height;
  final String? mimeType;
  final Breed? breed;

  Cat({
    required this.id,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.mimeType,
    this.breed,
  });

  factory Cat.fromDTO(CatDTO dto) {
    Breed? mappedBreed;
    if (dto.breeds != null && dto.breeds!.isNotEmpty) {
      mappedBreed = Breed.fromDTO(dto.breeds!.first);
    }
    return Cat(
      id: dto.id,
      imageUrl: dto.imageURL,
      width: dto.width,
      height: dto.height,
      mimeType: dto.mimeType,
      breed: mappedBreed,
    );
  }
}
