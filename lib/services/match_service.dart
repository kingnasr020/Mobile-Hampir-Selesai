import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/match_model.dart';

class MatchService {
  static const String baseUrl = "https://openmlbb.fastapicloud.dev/api";

  static Future<List<EsportsMatch>> fetchLiveMatches() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      EsportsMatch(
        teamAName: "EVOS Legends",
        teamBName: "Alter Ego",
        league: "MPL Indonesia S17",
        status: "live",
        liveUrl: "https://youtube.com",
        beginAt: "14:15 WIB",
        leagueLogo: "https://id-mpl.com/assets/images/logo-mpl.png",
      ),
    ];
  }

  static Future<HeroCounterData> fetchHeroCounters(String heroName) async {
  
    final String url = "$baseUrl/heroes/${heroName.toLowerCase()}/counters?days=1&rank=glory&size=20&index=1&lang=id";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return HeroCounterData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal narik data');
      }
    } catch (e) {
      rethrow;
    }
  }
}