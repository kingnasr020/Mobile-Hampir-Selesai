import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // Data Akun YouTube Pro Player Sesuai Folder Assets Proplayer Kamu
  final List<Map<String, dynamic>> proPlayerYoutubeList = [
    {
      'id': 1,
      'name': 'Jess No Limit',
      'role': '👑 Eks Pro Player & Pioneer MLBB Indo',
      'subscribers': '51.4M+ Subscribers',
      'excerpt':
          'Pelopor konten Mobile Legends terbesar di Indonesia sekaligus mantan core andalan top tier EVOS Legends.',
      'description':
          'Tobias Justin (Jess No Limit) adalah pelopor utama yang membesarkan skena Mobile Legends di Indonesia dari Season 1. Terkenal dengan kecepatan tangan (fast hand) saat menggunakan hero Assassin mekanik tinggi seperti Fanny, Gusion, dan Lancelot. Kanal YouTube-nya sangat wajib ditonton untuk mempelajari konsistensi bermain, trik menaikkan win rate, serta eksperimen build item META yang sering kali membuat musuh terkejut di Land of Dawn.',
      'avatar': '👑',
      'image': 'assets/proplayer/jess_no_limit.jpg',
      'isFeatured': true,
      'url': 'https://www.youtube.com/@JessNoLimit',
    },
    {
      'id': 2,
      'name': 'Kairi Official',
      'role': '🗡️ The Jungler / Assassin God',
      'subscribers': '2.1M+ Subscribers',
      'excerpt':
          'Mekanik jungler tingkat dewa dan rahasia rotasi super cepat ala ONIC Esports.',
      'description':
          'Kairi membagikan rahasia rotasi jungler super cepat, penguasaan hero assassin lincah seperti Ling, Hayabusa, dan Joy, serta cara mengamankan objektif Turtle/Lord dengan Retribution presisi.',
      'avatar': '🗡️',
      'image': 'assets/proplayer/kairi.jpg',
      'isFeatured': false,
      'url': 'https://youtube.com/@kairiplayz?si=PzV33nPM1zKxBwfn',
    },
    {
      'id': 3,
      'name': 'RRQ Lemon',
      'role': '👽 The Alien / King of Versatility',
      'subscribers': '5.7M+ Subscribers',
      'excerpt':
          'Pemain jenius dengan pool hero tak terbatas yang mampu menguasai seluruh role dengan makro taktik di luar nalar.',
      'description':
          'Muhammad Ikhsan (Lemon) dijuluki "Alien" karena kejeniusannya membaca draf pick dan kerap membawa hero non-META ke panggung kompetitif. Melalui channel YouTube resminya, Lemon secara konsisten membagikan tutorial makro kontrol tingkat tinggi, positioning aman saat war, serta rahasia mekanik hero-hero under-rated yang dioptimalkan dengan build item unik hingga menjadi kiblat META baru.',
      'avatar': '👽',
      'image': 'assets/proplayer/rrq_lemon.jpg',
      'isFeatured': false,
      'url': 'https://www.youtube.com/@rrq_lemon',
    },
    {
      'id': 4,
      'name': 'Sanz',
      'role': '🧙‍♂️ Mid Laner / Kage',
      'subscribers': '1.2M+ Subscribers',
      'excerpt':
          'Pakar Mid Lane dengan positioning dan perhitungan damage magic yang sangat akurat.',
      'description':
          'Gilang "Sanz" memberikan konten edukasi seputar penguasaan hero Mage, trik rotasi Midlane untuk back-up side lane, serta timing penggunaan skill ultimate yang bisa mengubah jalannya teamfight.',
      'avatar': '🧙‍♂️',
      'image': 'assets/proplayer/sanz.jpg',
      'isFeatured': false,
      'url': 'https://youtube.com/@sanzgilang10?si=9lm62Te_yoER29qM',
    },
    {
      'id': 5,
      'name': 'Gustian REKT',
      'role': '🏆 The Spine / M1 World Champion',
      'subscribers': '4.1M+ Subscribers',
      'excerpt':
          'Kapten legendaris pembawa pulang trofi M1. Pakar utama dalam urusan shotcall makro dan manajemen laning.',
      'description':
          'Gustian "REKT" adalah roamer dan goldlaner legendaris yang memiliki ketenangan luar biasa dalam mengambil keputusan makro game. Di YouTube-nya, REKT fokus menyajikan konten edukasi tingkat tinggi, mulai dari bedah draf pick tim MPL, trik melakukan zoning aman untuk core, manajemen gelombang minion (wave management), hingga cara membaca pergerakan jungler musuh secara presisi.',
      'avatar': '🏆',
      'image': 'assets/proplayer/gustian_rekt.jpg',
      'isFeatured': false,
      'url': 'https://youtube.com/@GustianREKT?si=5JQV3X5X5X5X5X5X',
    },
    {
      'id': 6,
      'name': 'XINNN',
      'role': '🔫 Gold Laner Bar-Bar',
      'subscribers': '3.8M+ Subscribers',
      'excerpt':
          'Mantan andalan RRQ dengan gaya main agresif, menguasai role Marksman dan Assassin.',
      'description':
          'Isaiah Omega "Xinnn" membagikan gameplay Gold Lane agresif, trik snowballing sejak early game, dan rahasia penempatan posisi Marksman saat late game agar tidak mudah di-pick off lawan.',
      'avatar': '🔫',
      'image': 'assets/proplayer/xinnn.jpg',
      'isFeatured': false,
      'url': 'https://www.youtube.com/@XINNN',
    },
    {
      'id': 7,
      'name': 'Oura Store',
      'role': '⚡ Bapak Offlaner',
      'subscribers': '7.9M+ Subscribers',
      'excerpt':
          'EXP Laner terbaik dunia pada masanya yang menyabet gelar MVP M1 berkat dominasi lane.',
      'description':
          'Eko Julianto (Oura) merupakan panutan utama bagi para pemain EXP Lane di Indonesia. Konten YouTube-nya sangat direkomendasikan bagi kamu yang ingin mendalami tugas memutus formasi lini belakang musuh saat war, trik split push yang aman, memenangkan duel mekanik 1v1 di side lane, serta cara menjaga kestabilan ekonomi gold tim.',
      'avatar': '⚡',
      'image': 'assets/proplayer/oura_store.jpg',
      'isFeatured': false,
      'url': 'https://www.youtube.com/@ouraekooju',
    },
  ];

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Gagal membuka channel YouTube, Nas! Periksa koneksi internet.'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF102A43),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Edukasi & Channel Pro Player OP',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _FeaturedPlayerWidget(
              data: proPlayerYoutubeList[0],
              onTap: () => _launchUrl(proPlayerYoutubeList[0]['url']),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rekomendasi Channel Pro Player',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF102A43),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF102A43),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: proPlayerYoutubeList.length - 1,
              itemBuilder: (context, index) {
                return _PlayerCardWidget(
                  data: proPlayerYoutubeList[index + 1],
                  onTap: () =>
                      _launchUrl(proPlayerYoutubeList[index + 1]['url']),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _FeaturedPlayerWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const _FeaturedPlayerWidget({
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF102A43).withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xFF102A43).withOpacity(0.06),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(14)),
                    child: Image.asset(
                      data['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            data['avatar'],
                            style: const TextStyle(fontSize: 55),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'KONTEN PALING OP',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF102A43),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data['role'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                  const Divider(height: 20),
                  Text(
                    data['description'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['subscribers'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.red.shade200, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_circle_fill,
                                size: 14, color: Colors.red.shade700),
                            const SizedBox(width: 6),
                            Text(
                              'Buka YouTube',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerCardWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const _PlayerCardWidget({
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF102A43).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    data['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          data['avatar'],
                          style: const TextStyle(fontSize: 30),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['name'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF102A43),
                          ),
                        ),
                        const Icon(
                          Icons.open_in_new_rounded,
                          size: 14,
                          color: Colors.red,
                        )
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      data['role'],
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      data['excerpt'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}