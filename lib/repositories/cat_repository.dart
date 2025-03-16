import 'package:catinder/services/cat_api_service.dart';
import '../models/cat.dart';

class CatRepository {
  final CatApiService apiService;

  CatRepository({required this.apiService});

  Future<Cat?> getRandomCat() async {
    final catDTO = await apiService.fetchRandomCat();
    if (catDTO != null) {
      return Cat.fromDTO(catDTO);
    }

    return null;
  }
}
