import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../dto/cat_dto.dart';

class CatApiService {
  final String _baseURL = "https://api.thecatapi.com/v1";
  final String _apiKey = dotenv.env['CAT_API_KEY'] ?? '';

  Future<CatDTO?> fetchRandomCat() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseURL/images/search?has_breeds=1'),
        headers: {
          'x-api-key': _apiKey,
        },
      );
      developer.log('API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        developer.log('Response data: $data');

        if (data.isNotEmpty) {
          final catData = data.first;
          if (catData != null) {
            return CatDTO.fromJson(catData);
          }
        }
      } else {
        developer.log('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      developer.log('Exception: $e');
    }

    return null;
  }

  Future<void> vote(String imageId, int value) async {
    await http.post(Uri.parse('$_baseURL/votes'),
        headers: {
          'x-api-key': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'image_id': imageId,
          'value': value,
        }));
  }
}
