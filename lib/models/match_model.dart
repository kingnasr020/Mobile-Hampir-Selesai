class HeroCounterData {
  final String mainHeroName;
  final String mainHeroImage;
  final double winRate;
  final List<SubHero> counters;

  HeroCounterData({
    required this.mainHeroName,
    required this.mainHeroImage,
    required this.winRate,
    required this.counters,
  });

  factory HeroCounterData.fromJson(Map<String, dynamic> json) {
    final records = json['data']['records'] as List;
    final deepData = records[0]['data'] as Map<String, dynamic>;
    final List subHeroList = deepData['sub_hero'] ?? [];

    return HeroCounterData(
      mainHeroName: deepData['main_hero']?['data']?['name'] ?? "Unknown",
      mainHeroImage: deepData['main_hero']?['data']?['head'] ?? "",
      winRate: (deepData['main_hero_win_rate'] as num).toDouble(),
      counters: subHeroList.map((item) => SubHero.fromJson(item)).toList(),
    );
  }
}

class SubHero {
  final int heroId; // KITA BALIKIN LAGI BIAR GAK MERAH
  final String image;
  final double winRate;
  final double winRateIncrease;

  SubHero({
    required this.heroId,
    required this.image,
    required this.winRate,
    required this.winRateIncrease,
  });

  factory SubHero.fromJson(Map<String, dynamic> json) {
    return SubHero(
      heroId: json['heroid'] ?? 0, // AMBIL ID DARI JSON
      image: json['hero']?['data']?['head'] ?? "",
      winRate: (json['hero_win_rate'] as num).toDouble(),
      winRateIncrease: (json['increase_win_rate'] as num).toDouble(),
    );
  }
}

class EsportsMatch {
  final String teamAName;
  final String teamBName;
  final String league;
  final String status;
  final String liveUrl;
  final String beginAt;
  final String leagueLogo;

  EsportsMatch({
    required this.teamAName,
    required this.teamBName,
    required this.league,
    required this.status,
    required this.liveUrl,
    required this.beginAt,
    required this.leagueLogo,
  });

  factory EsportsMatch.fromJson(Map<String, dynamic> json) {
    var opponents = json['opponents'] as List? ?? [];
    String logo = json['league']?['image_url'] ?? "https://via.placeholder.com/50";
    return EsportsMatch(
      teamAName: opponents.isNotEmpty ? (opponents[0]['opponent']['name'] ?? "TBD") : "TBD",
      teamBName: opponents.length > 1 ? (opponents[1]['opponent']['name'] ?? "TBD") : "TBD",
      league: json['league']?['name'] ?? "Unknown Tournament",
      status: json['status'] ?? "scheduled",
      liveUrl: (json['streams_list'] != null && (json['streams_list'] as List).isNotEmpty)
          ? (json['streams_list'][0]['raw_url'] ?? "") : "",
      beginAt: json['begin_at'] ?? "",
      leagueLogo: logo,
    );
  }
}