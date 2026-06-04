import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/match_model.dart';
import '../services/match_service.dart'; // Import service baru kita

class MatchDetailScreen extends StatefulWidget {
  final EsportsMatch match;

  const MatchDetailScreen({super.key, required this.match});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  String aiPrediction = "Gemini sedang menganalisis data pertandingan...";
  bool isAnalysing = true;
  HeroCounterData? heroData; // Untuk nampung data dari API ridwaanhall
  bool isLoadingCounter = true;

  @override
  void initState() {
    super.initState();
    _runAIAnalysis();
    _fetchCounterData(); // Panggil data counter pas layar dibuka
  }

  // Fungsi buat narik data counter (Contoh: Default cari counter Ling)
  void _fetchCounterData() async {
    try {
      // Kita coba cari counter untuk hero META saat ini (contoh: Ling)
      final data = await MatchService.fetchHeroCounters("Ling"); 
      if (mounted) {
        setState(() {
          heroData = data;
          isLoadingCounter = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoadingCounter = false);
    }
  }

  void _runAIAnalysis() async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash', 
        apiKey: 'AIzaSyAGHJseOc2POGKVKEswKrOrg8trfLWeFX4' 
      );

      final prompt = """
        Kamu adalah analis E-sports profesional khusus Mobile Legends (MLBB).
        Analisis match: ${widget.match.teamAName} vs ${widget.match.teamBName} di ${widget.match.league}.
        Gunakan gaya bahasa Caster MPL Indonesia yang seru dan teknis.
      """;

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (mounted) {
        setState(() {
          aiPrediction = response.text ?? "Gagal mendapatkan analisis.";
          isAnalysing = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isAnalysing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handling format tanggal agar aman dari error parsing
    DateTime localTime = DateTime.tryParse(widget.match.beginAt) ?? DateTime.now();
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(localTime);
    String formattedTime = DateFormat('HH:mm').format(localTime);

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Match Analysis & Counter"),
        backgroundColor: const Color(0xFF161B22),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. HEADER (LEAGUE)
            Center(
              child: Column(
                children: [
                  Image.network(widget.match.leagueLogo, height: 60, 
                    errorBuilder: (c, e, s) => const Icon(Icons.emoji_events, size: 50, color: Colors.amber)),
                  const SizedBox(height: 10),
                  Text(widget.match.league, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                  Text("$formattedDate | $formattedTime WIB", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 2. VS DISPLAY
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTeamDisplay(widget.match.teamAName, Colors.orange),
                const Text("VS", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                _buildTeamDisplay(widget.match.teamBName, Colors.blue),
              ],
            ),
            const SizedBox(height: 30),

            // 3. AI ANALYSIS BOX
            _buildSectionTitle(Icons.auto_awesome, "GEMINI AI ANALYSIS", Colors.amber),
            _buildContainer(
              isAnalysing 
                ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                : Text(aiPrediction, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5)),
            ),
            const SizedBox(height: 30),

            // 4. REAL-TIME HERO COUNTER (DATA DARI API RIDWAANHALL)
              _buildSectionTitle(Icons.security, "META COUNTER ANALYSIS (LING)", Colors.blueAccent),            _buildContainer(
              isLoadingCounter 
                ? const Center(child: CircularProgressIndicator())
                : (heroData == null)
                  ? const Text("Data counter tidak tersedia.", style: TextStyle(color: Colors.grey))
                  : Column(
                      children: heroData!.counters.take(3).map((hero) => ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(hero.image)),
                        title: Text("Counter ID: ${hero.heroId}", style: const TextStyle(color: Colors.white, fontSize: 14)),
                        subtitle: Text("Win Rate Increase: +${(hero.winRateIncrease * 100).toStringAsFixed(1)}%", 
                          style: const TextStyle(color: Colors.green, fontSize: 12)),
                      )).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  Widget _buildTeamDisplay(String name, Color color) {
    return Column(
      children: [
        CircleAvatar(radius: 35, backgroundColor: color.withOpacity(0.1), child: const Icon(Icons.shield, color: Colors.white)),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}