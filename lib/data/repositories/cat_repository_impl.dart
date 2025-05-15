import '../services/cat_api_service.dart';
import '../../domain/entities/cat.dart';

class CatRepositoryImpl {
  final CatApiService apiService;

  CatRepositoryImpl({required this.apiService});

  Future<Cat?> getRandomCat() async {
    final catDTO = await apiService.fetchRandomCat();
    if (catDTO != null) {
      return Cat.fromDTO(catDTO);
    }

    return null;
  }
}
