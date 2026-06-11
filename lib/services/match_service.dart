import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/match_model.dart';

class MatchService {
  static const String baseUrl = "https://openmlbb.fastapicloud.dev/api";

  // 1. Fungsi bawaan temanmu untuk data live match
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

  // 2. Fungsi bawaan temanmu untuk counter hero
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

  // 3. INTEGRASI API JADWAL MENDATANG
  static Future<List<dynamic>> getUpcomingMatches() async {
    final String url = "$baseUrl/matches/upcoming"; 

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (_) {
      // Fallback lokal agar aplikasi tetap bisa didemo saat server offline
    }

    return [
      {
        'date': 'Rabu, 10 Juni 2026',
        'time': '13:00 WIB',
        'match': 'Round 1 Match 1',
        'team1': 'DEWA United',
        'team2': 'GEEK Fam',
        'isLive': true,
      },
      {
        'date': 'Rabu, 10 Juni 2026',
        'time': '18:15 WIB',
        'match': 'Round 1 Match 2',
        'team1': 'Bigetron Alpha',
        'team2': 'EVOS Glory',
        'isLive': false,
      },
    ];
  }

  // 4. INTEGRASI API RIWAYAT HASIL PERTANDINGAN
  static Future<List<dynamic>> getPastResults() async {
    final String url = "$baseUrl/matches/results";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (_) {
      // Fallback lokal
    }

    return [
      {
        'date': 'Selasa, 9 Juni 2026',
        'time': '18:15 WIB',
        'match': 'Final Group Stage',
        'team1': 'Team Liquid ID',
        'team2': 'EVOS Glory',
        'score1': 2,
        'score2': 1,
      },
      {
        'date': 'Senin, 8 Juni 2026',
        'time': '13:00 WIB',
        'match': 'Group Stage MD10',
        'team1': 'Fnatic ONIC',
        'team2': 'Bigetron By VIT',
        'score1': 2,
        'score2': 0,
      },
    ];
  }
}