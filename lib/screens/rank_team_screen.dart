import 'package:flutter/material.dart';

class RankTeamScreen extends StatefulWidget {
  const RankTeamScreen({Key? key}) : super(key: key);

  @override
  State<RankTeamScreen> createState() => _RankTeamScreenState();
}

class _RankTeamScreenState extends State<RankTeamScreen> {
  final List<Map<String, dynamic>> rankingData = [
    {
      'rank': 1,
      'teamName': 'Fnatic ONIC',
      'wins': 13,
      'losses': 3,
      'winrate': 81.3,
      'isPlayoffZone': true,
    },
    {
      'rank': 2,
      'teamName': 'Team Liquid ID',
      'wins': 10,
      'losses': 6,
      'winrate': 62.5,
      'isPlayoffZone': true,
    },
    {
      'rank': 3,
      'teamName': 'DEWA United',
      'wins': 9,
      'losses': 7,
      'winrate': 56.3,
      'isPlayoffZone': true,
    },
    {
      'rank': 4,
      'teamName': 'Bigetron By VIT',
      'wins': 8,
      'losses': 8,
      'winrate': 50.0,
      'isPlayoffZone': true,
    },
    {
      'rank': 5,
      'teamName': 'EVOS',
      'wins': 8,
      'losses': 8,
      'winrate': 50.0,
      'isPlayoffZone': true,
    },
    {
      'rank': 6,
      'teamName': 'Geek Fam',
      'wins': 7,
      'losses': 9,
      'winrate': 43.8,
      'isPlayoffZone': true,
    },
    {
      'rank': 7,
      'teamName': 'Alter Ego Esports',
      'wins': 6,
      'losses': 10,
      'winrate': 37.5,
      'isPlayoffZone': false,
    },
    {
      'rank': 8,
      'teamName': 'NAVI',
      'wins': 5,
      'losses': 11,
      'winrate': 31.3,
      'isPlayoffZone': false,
    },
    {
      'rank': 9,
      'teamName': 'RRQ Hoshi',
      'wins': 4,
      'losses': 12,
      'winrate': 25.0,
      'isPlayoffZone': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF102A43),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Klasemen & Ranking',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _SeasonBannerWidget(),
            const SizedBox(height: 20),
            _PodiumWidget(rankingData: rankingData),
            const SizedBox(height: 24),
            _RankingTableWidget(rankingData: rankingData),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SeasonBannerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF102A43),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF102A43).withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MPL ID Season 17',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Regular Season Selesai',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.shade600,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'FASE PLAYOFFS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumWidget extends StatelessWidget {
  final List<Map<String, dynamic>> rankingData;

  const _PodiumWidget({required this.rankingData});

  @override
  Widget build(BuildContext context) {
    final first = rankingData[0];
    final second = rankingData[1];
    final third = rankingData[2];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Text(
            'Top 3 Teams',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF102A43),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _PodiumPositionWidget(
                  rank: 2,
                  teamName: second['teamName'],
                  wins: second['wins'],
                  losses: second['losses'],
                  winrate: second['winrate'],
                  height: 140,
                  borderColor: Colors.grey.shade400,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PodiumPositionWidget(
                  rank: 1,
                  teamName: first['teamName'],
                  wins: first['wins'],
                  losses: first['losses'],
                  winrate: first['winrate'],
                  height: 200,
                  borderColor: const Color(0xFFFFD700),
                  isFirst: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PodiumPositionWidget(
                  rank: 3,
                  teamName: third['teamName'],
                  wins: third['wins'],
                  losses: third['losses'],
                  winrate: third['winrate'],
                  height: 100,
                  borderColor: const Color(0xFFCD7F32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PodiumPositionWidget extends StatelessWidget {
  final int rank;
  final String teamName;
  final int wins;
  final int losses;
  final double winrate;
  final double height;
  final Color borderColor;
  final bool isFirst;

  const _PodiumPositionWidget({
    required this.rank,
    required this.teamName,
    required this.wins,
    required this.losses,
    required this.winrate,
    required this.height,
    required this.borderColor,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isFirst
                ? const Color(0xFFFFD700).withOpacity(0.2)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '#$rank',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: borderColor,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: height,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            border: Border.all(
              color: borderColor,
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                teamName,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF102A43),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              _PodiumStatsWidget(
                wins: wins,
                losses: losses,
                winrate: winrate,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PodiumStatsWidget extends StatelessWidget {
  final int wins;
  final int losses;
  final double winrate;

  const _PodiumStatsWidget({
    required this.wins,
    required this.losses,
    required this.winrate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$wins',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            ),
            Text(
              'W - ',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              '$losses',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
            Text(
              'L',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF102A43).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${winrate.toStringAsFixed(1)}% WR',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF102A43),
            ),
          ),
        ),
      ],
    );
  }
}

class _RankingTableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> rankingData;

  const _RankingTableWidget({required this.rankingData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const SizedBox(width: 8),
                SizedBox(
                  width: 30,
                  child: Text(
                    'Rank',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Tim',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 45,
                  child: Text(
                    'W-L',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 50,
                  child: Text(
                    'WR %',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rankingData.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (context, index) {
              return _RankingRowWidget(data: rankingData[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _RankingRowWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const _RankingRowWidget({required this.data});

  Color _getWinrateColor(double winrate) {
    if (winrate >= 70) {
      return const Color(0xFF4CAF50);
    } else if (winrate >= 50) {
      return const Color(0xFF2196F3);
    } else if (winrate >= 30) {
      return const Color(0xFFFF9800);
    } else {
      return const Color(0xFFF44336);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stripColor =
        data['isPlayoffZone'] ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    final winrateColor = _getWinrateColor(data['winrate']);

    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 40,
              decoration: BoxDecoration(
                color: stripColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 30,
              child: Text(
                '${data['rank']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF102A43),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                data['teamName'],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF102A43),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 45,
              child: Text(
                '${data['wins']}-${data['losses']}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF102A43),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${data['winrate'].toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF102A43),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: data['winrate'] / 100,
                      minHeight: 4,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(winrateColor),
                    ),
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