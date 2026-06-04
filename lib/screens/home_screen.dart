import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../services/match_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  HeroCounterData? _counterResult;
  bool _isLoadingCounter = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _searchHero(String name) async {
    if (name.isEmpty) return;
    setState(() {
      _isLoadingCounter = true;
      _counterResult = null;
    });

    try {
      final result = await MatchService.fetchHeroCounters(name);
      setState(() {
        _counterResult = result;
        _isLoadingCounter = false;
      });
    } catch (e) {
      setState(() => _isLoadingCounter = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hero '$name' gak ketemu Nas!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildBanner(),
          TabBar(
            controller: _tabController,
            tabs: const [Tab(text: "MATCH"), Tab(text: "RANK"), Tab(text: "COUNTER")],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const Center(child: Text("Match Soon")),
                const Center(child: Text("Rank Soon")),
                _buildCounterTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounterTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Cari hero (sun, ling, zilong...)",
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _searchHero(_searchController.text),
              ),
            ),
            onSubmitted: _searchHero,
          ),
          const SizedBox(height: 20),
          if (_isLoadingCounter) const CircularProgressIndicator(),
          if (_counterResult != null)
            Expanded(
              child: ListView(
                children: [
                  _buildMainHeroHeader(),
                  const SizedBox(height: 20),
                  const Text("REKOMENDASI COUNTER", style: TextStyle(fontWeight: FontWeight.bold)),
                  const Divider(),
                  ..._counterResult!.counters.asMap().entries.map((entry) {
                    int idx = entry.key + 1;
                    var hero = entry.value;
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(hero.image)),
                        title: Text("Counter #$idx", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("WR: ${(hero.winRate * 100).toStringAsFixed(1)}%"),
                        trailing: Text("+${(hero.winRateIncrease * 100).toStringAsFixed(1)}%", 
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ),
                    );
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainHeroHeader() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          CircleAvatar(radius: 30, backgroundImage: NetworkImage(_counterResult!.mainHeroImage)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_counterResult!.mainHeroName.toUpperCase(), 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text("Avg Win Rate: ${(_counterResult!.winRate * 100).toStringAsFixed(1)}%"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      color: const Color(0xFF102A43),
      child: const Text("MLBB ANALYTICS", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }
}