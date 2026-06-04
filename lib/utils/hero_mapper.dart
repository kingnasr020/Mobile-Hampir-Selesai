class HeroMapper {
  static const Map<int, String> _heroMap = {
    2: 'Balmond',
    3: 'Saber',
    7: 'Alucard',
    21: 'Hayabusa',
    24: 'Natalia',
    84: 'Ling',
    99: 'Diggie',
    102: 'Edith',
    118: 'Joy',
    121: 'Arlott',
  };

  static String getHeroName(int heroId) {
    return _heroMap[heroId] ?? 'Hero #$heroId';
  }
}