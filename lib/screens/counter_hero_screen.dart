import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../services/match_service.dart';

class CounterHeroScreen extends StatefulWidget {
  const CounterHeroScreen({Key? key}) : super(key: key);

  @override
  State<CounterHeroScreen> createState() => _CounterHeroScreenState();
}

class _CounterHeroScreenState extends State<CounterHeroScreen> {
  final TextEditingController _searchController = TextEditingController();
  HeroCounterData? _counterResult;
  bool _isLoadingCounter = false;

  static const Color _navy = Color(0xFF102A43);

  void _searchHero(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    final formattedName = trimmed.toLowerCase();

    setState(() {
      _isLoadingCounter = true;
      _counterResult = null;
    });

    try {
      final result = await MatchService.fetchHeroCounters(formattedName);
      if (!mounted) return;
      setState(() {
        _counterResult = result;
        _isLoadingCounter = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingCounter = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Hero '$trimmed' tidak ditemukan di server OpenMLBB."),
          backgroundColor: _navy,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: _navy,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Live Counter Draft Pick',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Live Data Counter Server',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _navy),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(5)),
                  child: const Text('● LIVE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cari hero (sun, ling, zilong...)',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send_rounded, color: _navy),
                  onPressed: () => _searchHero(_searchController.text),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _navy, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onSubmitted: _searchHero,
            ),
            const SizedBox(height: 20),
            if (_isLoadingCounter)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(color: _navy),
                ),
              ),
            if (_counterResult != null) ...[
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: NetworkImage(_counterResult!.mainHeroImage),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _counterResult!.mainHeroName.toUpperCase(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _navy),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Avg Win Rate: ${(_counterResult!.winRate * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'REKOMENDASI COUNTER',
                style: TextStyle(fontWeight: FontWeight.bold, color: _navy, fontSize: 13, letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _counterResult!.counters.length,
                itemBuilder: (context, index) {
                  final hero = _counterResult!.counters[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        backgroundImage: NetworkImage(hero.image),
                      ),
                      // 🔥 DI SINI BAGIAN YANG DIUBAH MENJADI ANGKA URUTAN
                      title: Text(
                        'COUNTER ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _navy),
                      ),
                      subtitle: Text('WR vs Hero: ${(hero.winRate * 100).toStringAsFixed(1)}%'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          '+${(hero.winRateIncrease * 100).toStringAsFixed(1)}%',
                          style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}