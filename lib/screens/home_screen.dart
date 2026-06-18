import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'news_screen.dart'; 
import 'counter_hero_screen.dart'; 
import 'quiz_screen.dart'; 
import 'info_hero_screen.dart'; 
import 'update_s41_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _carouselTimer;
  Timer? _seasonTimer;
  String _seasonCountdownText = "00 Hari : 00 Jam : 00 Menit : 00 Detik";

  // Data Carousel pake Link Web Asli
  final List<Map<String, String>> _carouselData = [
    {
      "title": "Hero Hirara Rilis Resmi 17 Juni 2026",
      "date": "17 Juni 2026",
      "image": "assets/images/news1.jpg",
      "url": "https://www.industry.co.id/read/151438/mobile-legends-patch-update-hero-hirara-rilis-resmi-17-juni-2026",
    },
    {
      "title": "Mengapa Bigetron by Vitality Merajai MPL S17",
      "date": "18 Juni 2026",
      "image": "assets/images/news2.jpg",
      "url": "https://www.kompas.id/artikel/mengapa-bigetron-by-vitality-merajai-mpl-indonesia-season-ke-17",
    },
    {
      "title": "Cara Dapatkan Skin Zhask Ice-Spawn Gratis di S41",
      "date": "16 Juni 2026",
      "image": "assets/images/news3.jpg",
      "url": "https://www.industry.co.id/read/151549/mobile-legends-cara-dapatkan-skin-zhask-icespawn-scourge-gratis-di-season-41",
    },
    {
      "title": "Patch MLBB S41: Revamp Aulus & Ubah META",
      "date": "22 April 2026",
      "image": "assets/images/news4.jpg",
      "url": "https://memorandum.disway.id/gaya-hidup/read/157330/patch-mlbb-22-april-2026-revamp-aulus-dan-detail-lengkap-buffnerf-yang-ubah-meta",
    },
  ];

  static const Color _navy = Color(0xFF102A43);
  static const Color _lightGrey = Color(0xFFF0F4F8);

  @override
  void initState() {
    super.initState();

    final DateTime targetDate = DateTime(2026, 9, 15, 15, 0, 0);

    _seasonTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final DateTime now = DateTime.now();
      final Duration difference = targetDate.difference(now);

      if (difference.isNegative) {
        _seasonTimer?.cancel();
        if (mounted) {
          setState(() {
            _seasonCountdownText = "Season S41 Berakhir";
          });
        }
      } else {
        if (mounted) {
          setState(() {
            final String dStr = difference.inDays.toString().padLeft(2, '0');
            final String hStr = (difference.inHours % 24).toString().padLeft(2, '0');
            final String mStr = (difference.inMinutes % 60).toString().padLeft(2, '0');
            final String sStr = (difference.inSeconds % 60).toString().padLeft(2, '0');
            _seasonCountdownText = "$dStr H : $hStr J : $mStr M : $sStr D";
          });
        }
      }
    });

    _carouselTimer = Timer.periodic(const Duration(milliseconds: 3500), (Timer timer) {
      if (_currentPage < _carouselData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _seasonTimer?.cancel();
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // Buka URL ke Web Browser
  Future<void> _launchNewsUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuka berita: $e')),
        );
      }
    }
  }

  // Buka Aplikasi MLBB
  Future<void> _launchMLBB(BuildContext context) async {
    final Uri url = Uri.parse('https://play.google.com/store/apps/details?id=com.mobile.legends');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuka aplikasi: $e')),
        );
      }
    }
  }

  void _showMLBBConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.launch_rounded, color: Color(0xFF102A43)),
              SizedBox(width: 8),
              Text('Buka Mobile Legends?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: const Text(
            'Anda akan diarahkan untuk membuka aplikasi Mobile Legends. Lanjutkan?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF102A43),
              ),
              onPressed: () { 
                Navigator.pop(context); 
                _launchMLBB(context); 
              },
              child: const Text('Buka MLBB', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightGrey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 8, bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSeasonBanner(),
            const _SectionLabel('Edukasi Makro & Update Berita'),
            _buildVideoCarousel(),
            const _SectionLabel('Fitur Pintasan Analitik'),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  // --- BANNER DI KLIK MASUK KE UPDATE S41 ---
  Widget _buildSeasonBanner() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const UpdateS41Screen()));
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF102A43), Color(0xFF1B4870)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _navy.withOpacity(0.35), 
              blurRadius: 14, 
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 7, 
                        height: 7, 
                        decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'SISA WAKTU SEASON S41', 
                        style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _seasonCountdownText, 
                      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.amber.withOpacity(0.45), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: const Column(
                children: [
                  Icon(Icons.open_in_new_rounded, size: 13, color: Colors.white),
                  SizedBox(height: 2),
                  Text(
                    'DETAIL', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCarousel() {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _carouselData.length,
            itemBuilder: (context, index) {
              var item = _carouselData[index];
              return GestureDetector(
                onTap: () => _launchNewsUrl(item['url']!), // BUKA BROWSER OTOMATIS
                child: Card(
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          item['image']!,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300, 
                              child: const Center(
                                child: Icon(Icons.image, size: 50, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.9), 
                                Colors.black.withOpacity(0.3), 
                                Colors.transparent
                              ],
                              stops: const [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0, 
                        left: 0, 
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item['date']!, 
                                style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['title']!, 
                                maxLines: 2, 
                                overflow: TextOverflow.ellipsis, 
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10, 
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent, 
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.language_rounded, color: Colors.white, size: 11),
                              SizedBox(width: 4),
                              Text(
                                'BUKA WEB', 
                                style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_carouselData.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: _currentPage == index ? 18 : 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.amber : Colors.white60, 
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16), 
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12),
        ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 24,
        crossAxisSpacing: 4,
        childAspectRatio: 0.9,
        children: [
          _buildMenuButton(
            icon: Icons.person_search_rounded, 
            label: 'Info Hero', 
            tag: 'API', 
            color: Colors.teal, 
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoHeroScreen()));
            },
          ),
          _buildMenuButton(
            icon: Icons.new_releases_rounded, 
            label: 'Update S41', 
            tag: 'NEW', 
            color: Colors.orange, 
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const UpdateS41Screen()));
            },
          ),
          _buildMenuButton(
            icon: Icons.shield_rounded, 
            label: 'Counter Hero', 
            tag: 'META', 
            color: Colors.red, 
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CounterHeroScreen()));
            },
          ),
          _buildMenuButton(
            icon: Icons.play_circle_fill_rounded, 
            label: 'Channel OP', 
            tag: 'YOUTUBE', 
            color: Colors.purple, 
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NewsScreen()));
            },
          ),
          _buildMenuButton(
            icon: Icons.gamepad_rounded, 
            label: 'Mini Game', 
            tag: 'FUN', 
            color: Colors.blue, 
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen()));
            },
          ),
          _buildMenuButton(
            icon: Icons.launch_rounded, 
            label: 'Buka MLBB', 
            tag: 'PLAY', 
            color: const Color(0xFF102A43), 
            onTap: () {
              _showMLBBConfirmationDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon, 
    required String label, 
    required String? tag, 
    required Color color, 
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48, 
                height: 48, 
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12), 
                  shape: BoxShape.circle,
                ), 
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 6),
              Text(
                label, 
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, height: 1.2), 
                textAlign: TextAlign.center,
              ),
            ],
          ),
          if (tag != null)
            Positioned(
              top: -7, 
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), 
                decoration: BoxDecoration(
                  color: color, 
                  borderRadius: BorderRadius.circular(6),
                ), 
                child: Text(
                  tag, 
                  style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), 
      child: Text(
        text, 
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF102A43)),
      ),
    );
  }
}