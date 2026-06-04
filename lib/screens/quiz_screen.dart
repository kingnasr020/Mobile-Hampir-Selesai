import 'package:flutter/material.dart';
import 'dart:async';
import '../services/database_helper.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentLevel = 1;
  int _questionIndex = 0;
  int _score = 0;
  int _correctAnswersCount = 0;
  int _secondsLeft = 15;
  Timer? _timer;
  bool _isGameOver = false;
  bool _hasStarted = false;
  int? _selectedOptionIndex;
  bool _isAnswered = false;

  final List<Map<String, dynamic>> _allQuestions = [
    // LEVEL 1: INITIATE (EASY)
    {
      "q": "Hero apa yang punya skill 'Ultimate' bernama 'Way of the Dragon'?",
      "a": ["Chou", "Paquito", "Lee Sin", "Lancelot"],
      "correct": 0,
      "lv": 1
    },
    {
      "q": "Siapa Pro Player yang dijuluki 'The Alien'?",
      "a": ["Kairi", "Lemon", "Alberttt", "Sanz"],
      "correct": 1,
      "lv": 1
    },
    {
      "q": "MPL adalah singkatan dari...",
      "a": [
        "Mobile Professional League",
        "MLBB Professional League",
        "Mobile Premier League",
        "Mabar Pro League"
      ],
      "correct": 1,
      "lv": 1
    },
    {
      "q": "BTR Alpha dikenal dengan julukan?",
      "a": ["Raja Langit", "Macan Putih", "Robot Merah", "Landak"],
      "correct": 2,
      "lv": 1
    },
    {
      "q": "Berapa jumlah pemain dalam satu tim Mobile Legends?",
      "a": ["4", "5", "6", "11"],
      "correct": 1,
      "lv": 1
    },
    {
      "q": "Siapa kapten dari tim Fnatic ONIC?",
      "a": ["Kiboy", "Butsss", "Sanz", "Kairi"],
      "correct": 1,
      "lv": 1
    },
    {
      "q": "Apa nama map utama di Mobile Legends?",
      "a": ["Erangel", "Sanrio", "Land of Dawn", "Summoners Rift"],
      "correct": 2,
      "lv": 1
    },
    {
      "q": "Hero apa yang naik hiu?",
      "a": ["Akai", "Bane", "Baxia", "Fredrinn"],
      "correct": 1,
      "lv": 1
    },
    {
      "q": "Role yang bertugas menjaga Gold Lane biasanya adalah...",
      "a": ["Assassin", "Marksman", "Tank", "Mage"],
      "correct": 1,
      "lv": 1
    },
    {
      "q": "Warna identitas tim EVOS adalah?",
      "a": ["Merah", "Kuning", "Biru", "Hijau"],
      "correct": 2,
      "lv": 1
    },

    // LEVEL 2: ELITE (MEDIUM)
    {
      "q": "Siapa juara M1 World Championship?",
      "a": ["RRQ Hoshi", "EVOS Legends", "Todak", "Bren"],
      "correct": 1,
      "lv": 2
    },
    {
      "q": "Tim mana yang memenangkan MSC 2023?",
      "a": ["Blacklist", "ECHO", "ONIC Esports", "TNC"],
      "correct": 2,
      "lv": 2
    },
    {
      "q": "Venue MPL ID S13 diadakan di...",
      "a": ["Istora", "XO Hall", "Taman Anggrek", "Senayan"],
      "correct": 1,
      "lv": 2
    },
    {
      "q": "Item 'Sea Halberd' digunakan untuk counter hero...",
      "a": ["Darah Tebal", "Attack Speed", "Regen/Lifesteal", "Burst Damage"],
      "correct": 2,
      "lv": 2
    },
    {
      "q": "Apa nama piala dunia Mobile Legends?",
      "a": ["M-Series", "MSC", "MPL", "IESF"],
      "correct": 0,
      "lv": 2
    },
    {
      "q": "Siapa roamer andalan RRQ yang dijuluki Vyn?",
      "a": ["Calvin", "Vyn", "Vynnn", "Bang Vyn"],
      "correct": 1,
      "lv": 2
    },
    {
      "q": "Hero 'Fanny' sangat bergantung pada...",
      "a": ["Mana", "Energy", "Rage", "Stamina"],
      "correct": 1,
      "lv": 2
    },
    {
      "q": "Siapa MVP M4 World Championship?",
      "a": ["Karltzy", "Oheb", "Bennyqt", "Sanford"],
      "correct": 2,
      "lv": 2
    },
    {
      "q": "Tim 'Geek Fam' berasal dari negara?",
      "a": ["Filipina", "Indonesia", "Malaysia", "Singapura"],
      "correct": 1,
      "lv": 2
    },
    {
      "q": "Berapa cooldown Battle Spell 'Retribution'?",
      "a": ["35s", "45s", "50s", "30s"],
      "correct": 0,
      "lv": 2
    },

    // LEVEL 3: GLORY (HARD)
    {
      "q": "Item apa yang punya atribut 'Physical Pen' tertinggi?",
      "a": ["Malefic Roar", "Blade of Despair", "Sea Halberd", "Rose Gold"],
      "correct": 0,
      "lv": 3
    },
    {
      "q": "Siapa nama asli dari pro player 'Kairi'?",
      "a": ["Kairi Rayoselsol", "Kairi Yeb", "Kairi Khezcute", "Kairi Sanz"],
      "correct": 0,
      "lv": 3
    },
    {
      "q": "Berapa base damage dari 'Execute' pada level 1?",
      "a": ["100", "200", "250", "400"],
      "correct": 1,
      "lv": 3
    },
    {
      "q": "Spell apa yang bisa menghapus efek CC?",
      "a": ["Sprint", "Purify", "Aegis", "Petrify"],
      "correct": 1,
      "lv": 3
    },
    {
      "q": "Siapa pencipta game Mobile Legends?",
      "a": ["Tencent", "Moonton", "Garena", "Riot"],
      "correct": 1,
      "lv": 3
    },
    {
      "q": "Negara mana yang menang IESF 2022 MLBB?",
      "a": ["Filipina", "Indonesia", "Malaysia", "Kamboja"],
      "correct": 1,
      "lv": 3
    },
    {
      "q": "Hero apa yang bisa copy skill musuh?",
      "a": ["Luo Yi", "Valentina", "Vexana", "Faramis"],
      "correct": 1,
      "lv": 3
    },
    {
      "q": "Apa nama pasif dari hero 'Ling'?",
      "a": [
        "Cloud Walker",
        "Defiant Sword",
        "Finch Poise",
        "Tempest of Blades"
      ],
      "correct": 0,
      "lv": 3
    },
    {
      "q": "Item 'Immortal' memberikan pasif bangkit kembali setelah...",
      "a": ["2s", "2.5s", "3s", "1s"],
      "correct": 1,
      "lv": 3
    },
    {
      "q": "Tim Filipina pertama yang juara M-Series adalah?",
      "a": ["ECHO", "Bren Esports", "Blacklist", "AP Bren"],
      "correct": 1,
      "lv": 3
    },
  ];

  List<Map<String, dynamic>> _filteredQuestions = [];

  void _startQuiz(int level) {
    setState(() {
      _currentLevel = level;
      List<Map<String, dynamic>> temp =
          _allQuestions.where((q) => q['lv'] == level).toList();
      temp.shuffle();
      _filteredQuestions = temp.take(10).toList();
      _hasStarted = true;
      _questionIndex = 0;
      _score = 0;
      _correctAnswersCount = 0;
      _isGameOver = false;
      _selectedOptionIndex = null;
      _isAnswered = false;
      _startTimer();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_secondsLeft > 0) {
            _secondsLeft--;
          } else {
            _handleAnswer(-1);
          }
        });
      }
    });
  }

  void _handleAnswer(int index) {
    if (_isAnswered) return;
    _timer?.cancel();
    setState(() {
      _isAnswered = true;
      _selectedOptionIndex = index;
      if (index == _filteredQuestions[_questionIndex]['correct']) {
        _score += 10;
        _correctAnswersCount++;
      }
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          if (_questionIndex < _filteredQuestions.length - 1) {
            _questionIndex++;
            _selectedOptionIndex = null;
            _isAnswered = false;
            _startTimer();
          } else {
            _isGameOver = true;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFFD9E2EC), Color(0xFFF0F4F8)],
              ),
            ),
          ),
          SafeArea(
            child: !_hasStarted
                ? _buildLevelPicker()
                : (_isGameOver ? _buildResult() : _buildQuizBody()),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("MPL ID SEASON 17",
              style: TextStyle(
                  color: Color(0xFF102A43),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4)),
          const Text("CHALLENGE",
              style: TextStyle(
                  color: Color(0xFF102A43),
                  fontSize: 42,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 40),
          _levelCard("INITIATE", "Level: Easy", 1, Colors.blue),
          _levelCard("ELITE", "Level: Medium", 2, Colors.indigo),
          _levelCard("GLORY", "Level: Hard", 3, const Color(0xFFD9480F)),
          const SizedBox(height: 30),
          const Text("Pilih rank kuis kamu Nas!",
              style: TextStyle(
                  color: Colors.blueGrey, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _levelCard(String title, String subtitle, int lv, Color color) {
    return GestureDetector(
      onTap: () => _startQuiz(lv),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontWeight: FontWeight.w900)),
                Text(subtitle, style: const TextStyle(color: Colors.blueGrey)),
              ],
            ),
            Icon(Icons.play_circle_fill, color: color, size: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizBody() {
    final currentQ = _filteredQuestions[_questionIndex];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("SOAL ${_questionIndex + 1}/10",
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, color: Color(0xFF102A43))),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _secondsLeft < 5
                      ? Colors.redAccent
                      : const Color(0xFF102A43),
                  borderRadius: BorderRadius.circular(15),
                ),
                // FIX: Menghilangkan huruf 's' di variabel _secondsLeft
                child: Text("$_secondsLeft",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: (_questionIndex + 1) / 10,
            backgroundColor: Colors.white,
            color: const Color(0xFF62B1F6),
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)
              ],
            ),
            child: Text(currentQ['q'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF102A43))),
          ),
          const Spacer(),
          ...List.generate(
              4,
              (i) =>
                  _buildOptionCard(i, currentQ['a'][i], currentQ['correct'])),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOptionCard(int index, String text, int correct) {
    Color cardColor = Colors.white;
    Color borderColor = Colors.transparent;

    if (_isAnswered) {
      if (index == correct) {
        cardColor = Colors.green[50]!;
        borderColor = Colors.green;
      } else if (index == _selectedOptionIndex) {
        cardColor = Colors.red[50]!;
        borderColor = Colors.red;
      }
    }

    return GestureDetector(
      onTap: () => _handleAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)
          ],
        ),
        child: Center(
            child: Text(text,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF102A43)))),
      ),
    );
  }

  Widget _buildResult() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events_rounded,
                color: Color(0xFFF6AD55), size: 100),
            const Text("VICTORY",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF102A43),
                    letterSpacing: 5)),
            Text("Berhasil menjawab $_correctAnswersCount soal",
                style: const TextStyle(color: Colors.blueGrey)),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Column(
                children: [
                  const Text("SKOR AKHIR",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                  Text("$_score",
                      style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF102A43))),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF102A43),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () async {
                final db = DatabaseHelper();

                if (_score >= 80) {
                  await db.addCoins(20);

                  int coinNow = await db.getCoins();
                  print("COIN SETELAH +20 = $coinNow");
                } else if (_score >= 50) {
                  await db.addCoins(10);

                  int coinNow = await db.getCoins();
                  print("COIN SETELAH +10 = $coinNow");
                } else {
                  await db.addCoins(5);

                  int coinNow = await db.getCoins();
                  print("COIN SETELAH +5 = $coinNow");
                }

                if (context.mounted) {
                  int reward = 5;

                  if (_score >= 80) {
                    reward = 20;
                  } else if (_score >= 50) {
                    reward = 10;
                  }

                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text(
                        "Selamat!",
                      ),
                      content: Text(
                        "Anda mendapatkan $reward coin",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);

                            Navigator.pop(
                              context,
                              true,
                            );
                          },
                          child: const Text(
                            "OK",
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text(
                "KEMBALI KE LOBBY",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
