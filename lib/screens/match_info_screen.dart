import 'package:flutter/material.dart';
import '../services/match_service.dart'; // Pastikan path service ini sudah benar
import '../models/match_model.dart';   // Tempat model data pertandingan kamu

class MatchInfoScreen extends StatefulWidget {
  const MatchInfoScreen({Key? key}) : super(key: key);

  @override
  State<MatchInfoScreen> createState() => _MatchInfoScreenState();
}

class _MatchInfoScreenState extends State<MatchInfoScreen> {
  late Future<List<dynamic>> _fetchUpcomingMatches;
  late Future<List<dynamic>> _fetchPastMatches;

  @override
  void initState() {
    super.initState();
    // Mengambil data live dari API Server saat halaman pertama kali dimuat
    _fetchUpcomingMatches = MatchService.getUpcomingMatches();
    _fetchPastMatches = MatchService.getPastResults();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8),
        appBar: AppBar(
          backgroundColor: const Color(0xFF102A43),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Jadwal & Hasil Pertandingan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            indicatorWeight: 3,
            unselectedLabelColor: Colors.white60,
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: 'Jadwal Mendatang'),
              Tab(text: 'Hasil Pertandingan'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildScheduleTab(),
            _buildResultsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTab() {
    return FutureBuilder<List<dynamic>>(
      future: _fetchUpcomingMatches,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF102A43)));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Gagal memuat jadwal atau data kosong.', style: TextStyle(color: Colors.grey)),
          );
        }

        final scheduleList = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: scheduleList.length,
          itemBuilder: (context, index) {
            return _MatchCardWidget(data: scheduleList[index]);
          },
        );
      },
    );
  }

  Widget _buildResultsTab() {
    return FutureBuilder<List<dynamic>>(
      future: _fetchPastMatches,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF102A43)));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('Gagal memuat hasil pertandingan.', style: TextStyle(color: Colors.grey)),
          );
        }

        final resultsList = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: resultsList.length,
          itemBuilder: (context, index) {
            return _MatchResultCardWidget(data: resultsList[index]);
          },
        );
      },
    );
  }
}

class _MatchCardWidget extends StatefulWidget {
  final dynamic data;

  const _MatchCardWidget({required this.data});

  @override
  State<_MatchCardWidget> createState() => _MatchCardWidgetState();
}

class _MatchCardWidgetState extends State<_MatchCardWidget> with TickerProviderStateMixin {
  late AnimationController _blinkController;
  bool _isLive = false;

  @override
  void initState() {
    super.initState();
    _isLive = widget.data['isLive'] ?? false;
    if (_isLive) {
      _blinkController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      )..repeat();
    }
  }

  @override
  void dispose() {
    if (_isLive) {
      _blinkController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data['date'] ?? '',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF102A43)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.data['time'] ?? ''} • ${widget.data['match'] ?? ''}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                if (_isLive)
                  FadeTransition(
                    opacity: _blinkController.drive(Tween<double>(begin: 0.4, end: 1.0)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '● LIVE',
                        style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                  ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Color(0xFFF0F4F8)),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          widget.data['team1'] ?? '',
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF102A43)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                        child: const Icon(Icons.shield, size: 18, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF102A43).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'VS',
                    style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                        child: const Icon(Icons.shield, size: 18, color: Colors.blueGrey),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.data['team2'] ?? '',
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF102A43)),
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
    );
  }
}

class _MatchResultCardWidget extends StatelessWidget {
  final dynamic data;

  const _MatchResultCardWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['date'] ?? '',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF102A43)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${data['time'] ?? ''} • ${data['match'] ?? ''}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green.shade200, width: 0.5),
                  ),
                  child: Text(
                    'SELESAI',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green.shade700, letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Color(0xFFF0F4F8)),
            ),
            _ResultMatchupWidget(
              team1: data['team1'] ?? '',
              score1: data['score1'] ?? 0,
              team2: data['team2'] ?? '',
              score2: data['score2'] ?? 0,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultMatchupWidget extends StatelessWidget {
  final String team1;
  final int score1;
  final String team2;
  final int score2;

  const _ResultMatchupWidget({
    required this.team1,
    required this.score1,
    required this.team2,
    required this.score2,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTeam1Winner = score1 > score2;
    final bool isTeam2Winner = score2 > score1;

    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  team1,
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isTeam1Winner ? FontWeight.bold : FontWeight.w500,
                    color: isTeam1Winner ? const Color(0xFF102A43) : Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                child: const Icon(Icons.shield, size: 18, color: Colors.blueGrey),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 14),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF102A43).withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                '$score1',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isTeam1Winner ? Colors.orange.shade700 : const Color(0xFF102A43),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Text(':', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
              Text(
                '$score2',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isTeam2Winner ? Colors.orange.shade700 : const Color(0xFF102A43),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                child: const Icon(Icons.shield, size: 18, color: Colors.blueGrey),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  team2,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isTeam2Winner ? FontWeight.bold : FontWeight.w500,
                    color: isTeam2Winner ? const Color(0xFF102A43) : Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}