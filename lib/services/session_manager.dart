import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {

  static const String _isLoggedInKey =
      "isLoggedIn";

  static const String _usernameKey =
      "username";

  static const String _nameKey =
      "name";

  static const String _nimKey =
      "nim";

  // =====================
  // SIMPAN SESSION
  // =====================

  static Future<void> saveSession({
    required String username,
    required String name,
    required String nim,
  }) async {

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.setBool(
      _isLoggedInKey,
      true,
    );

    await prefs.setString(
      _usernameKey,
      username,
    );

    await prefs.setString(
      _nameKey,
      name,
    );

    await prefs.setString(
      _nimKey,
      nim,
    );
  }

  // =====================
  // USERNAME
  // =====================

  static Future<String?> getUsername()
      async {

    final prefs =
        await SharedPreferences
            .getInstance();

    return prefs.getString(
      _usernameKey,
    );
  }

  // =====================
  // NAMA
  // =====================

  static Future<String?> getName()
      async {

    final prefs =
        await SharedPreferences
            .getInstance();

    return prefs.getString(
      _nameKey,
    );
  }

  // =====================
  // NIM
  // =====================

  static Future<String?> getNim()
      async {

    final prefs =
        await SharedPreferences
            .getInstance();

    return prefs.getString(
      _nimKey,
    );
  }

  // =====================
  // CEK LOGIN
  // =====================

  static Future<bool> isLoggedIn()
      async {

    final prefs =
        await SharedPreferences
            .getInstance();

    return prefs.getBool(
          _isLoggedInKey,
        ) ??
        false;
  }

  // =====================
  // LOGOUT
  // =====================

  static Future<void> logout()
      async {

    final prefs =
        await SharedPreferences
            .getInstance();

    await prefs.clear();
  }
}