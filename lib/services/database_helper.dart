import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(
      await getDatabasesPath(),
      'esports_pulse.db',
    );

    return await openDatabase(
      path,
      version: 7,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT UNIQUE,
          password TEXT,
          name TEXT,
          nim TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE teams(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT UNIQUE,
          logo_url TEXT,
          primary_color TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE coins(
          id INTEGER PRIMARY KEY,
          amount INTEGER
        )
        ''');

        await db.execute('''
        CREATE TABLE feedbacks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          nim TEXT,
          rating INTEGER,
          comment TEXT,
          created_at TEXT
        )
        ''');

        await db.insert(
          'coins',
          {
            'id': 1,
            'amount': 50,
          },
        );

        await db.execute('''
        CREATE TABLE transactions(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          transaction_id TEXT,
          ml_id TEXT,
          server_id TEXT,
          diamond INTEGER,
          price INTEGER,
          discount INTEGER,
          total INTEGER,
          payment_method TEXT,
          date TEXT,
          status TEXT
        )
        ''');
      },
    );
  }

  // =====================
  // USER
  // =====================

  Future<int> registerUser(
    String username,
    String password,
    String name,
    String nim,
  ) async {
    final db = await database;

    var bytes = utf8.encode(password);

    var digest = sha256.convert(bytes);

    return await db.insert(
      'users',
      {
        'username': username,
        'password': digest.toString(),
        'name': name,
        'nim': nim,
      },
    );
  }

  Future<bool> loginUser(
    String username,
    String password,
  ) async {
    final db = await database;

    var bytes = utf8.encode(password);

    var digest = sha256.convert(bytes);

    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [
        username,
        digest.toString(),
      ],
    );

    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>?> getUserByUsername(
    String username,
  ) async {
    final db = await database;

    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  Future<bool> verifyPassword(
    String username,
    String password,
  ) async {
    final db = await database;

    var bytes = utf8.encode(password);

    var digest = sha256.convert(bytes);

    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [
        username,
        digest.toString(),
      ],
    );

    return result.isNotEmpty;
  }

  // =====================
  // TEAM
  // =====================

  Future<void> upsertTeam(
    String name,
    String logoUrl,
    String colorHex,
  ) async {
    final db = await database;

    await db.insert(
      'teams',
      {
        'name': name,
        'logo_url': logoUrl,
        'primary_color': colorHex,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllTeams() async {
    final db = await database;

    return await db.query('teams');
  }

  // =====================
  // COIN
  // =====================

  Future<int> getCoins() async {
    final db = await database;

    var result = await db.query(
      'coins',
      where: 'id = ?',
      whereArgs: [1],
    );

    return result.first['amount'] as int;
  }

  Future<void> addCoins(
    int coin,
  ) async {
    final db = await database;

    int current = await getCoins();

    int newCoin = current + coin;

    await db.update(
      'coins',
      {
        'amount': newCoin,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<void> useCoin(
    int usedCoin,
  ) async {
    final db = await database;

    int current = await getCoins();

    int remain = current - usedCoin;

    if (remain < 0) {
      remain = 0;
    }

    await db.update(
      'coins',
      {
        'amount': remain,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  // =====================
  // TRANSACTION
  // =====================

  Future<void> saveTransaction({
    required String transactionId,
    required String mlId,
    required String serverId,
    required int diamond,
    required int price,
    required int discount,
    required int total,
    required String paymentMethod,
    required String date,
    required String status,
  }) async {
    final db = await database;

    await db.insert(
      'transactions',
      {
        'transaction_id': transactionId,
        'ml_id': mlId,
        'server_id': serverId,
        'diamond': diamond,
        'price': price,
        'discount': discount,
        'total': total,
        'payment_method': paymentMethod,
        'date': date,
        'status': status,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;

    return await db.query(
      'transactions',
      orderBy: 'id DESC',
    );
  }
    // =====================
  // FEEDBACK
  // =====================

  Future<void> saveFeedback({
    required String name,
    required String nim,
    required int rating,
    required String comment,
  }) async {

    final db = await database;

    await db.insert(
      'feedbacks',
      {
        'name': name,
        'nim': nim,
        'rating': rating,
        'comment': comment,
        'created_at':
            DateTime.now().toString(),
      },
    );
  }

  Future<List<Map<String, dynamic>>>
      getFeedbacks() async {

    final db = await database;

    return await db.query(
      'feedbacks',
      orderBy: 'id DESC',
    );
  }
  
}

