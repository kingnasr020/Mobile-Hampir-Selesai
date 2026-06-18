import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  // Mengambil key dengan aman
  static final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";

  static Future<String> getAiResponse(String prompt) async {
    if (_apiKey.isEmpty) return "Error: API Key tidak ditemukan.";

    final model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
    
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? "Tidak ada respon dari AI.";
    } catch (e) {
      return "Error koneksi: $e";
    }
  }
}