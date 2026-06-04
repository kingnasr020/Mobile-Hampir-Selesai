import 'package:shared_preferences/shared_preferences.dart';

class CoinService {

  static const String coinKey = "user_coin";

  static Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(coinKey) ?? 0;
  }

  static Future<void> addCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();

    int currentCoin =
        prefs.getInt(coinKey) ?? 0;

    await prefs.setInt(
      coinKey,
      currentCoin + amount,
    );
  }

  static Future<void> useCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();

    int currentCoin =
        prefs.getInt(coinKey) ?? 0;

    await prefs.setInt(
      coinKey,
      currentCoin - amount,
    );
  }

  static Future<void> resetCoin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(coinKey, 0);
  }
}