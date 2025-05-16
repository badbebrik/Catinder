import '../dto/cat_dto.dart';
import '../services/cat_api_service.dart';

class RemoteCatDatasource {
  final CatApiService api;

  RemoteCatDatasource({required this.api});

  Future<CatDTO?> fetchRandomCat() => api.fetchRandomCat();
  Future<void> vote(String imageId, int value) => api.vote(imageId, value);
}
