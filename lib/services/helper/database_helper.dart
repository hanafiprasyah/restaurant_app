import 'package:restaurant_app/models/restaurant/restaurant.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _table = 'favourite';

  Future<Database> _initDB() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/restaurant.db',
      onCreate: (db, version) async {
        await db.execute(
            '''CREATE TABLE $_table (id TEXT PRIMARY KEY, name TEXT, description TEXT, pictureId TEXT, city TEXT, rating DOUBLE)''');
      },
      version: 1,
    );
    return db;
  }

  Future<Database?> get database async {
    /// if _database == null, then init DB, set default to null
    _database ??= await _initDB();
    return _database;
  }

  /// Save favourite to storage
  Future<void> saveFavourite(RestaurantElement restaurantElement) async {
    final db = await database;
    await db!.insert(_table, restaurantElement.toJson());
  }

  /// Get favourite list from storage
  Future<List<RestaurantElement>> getFavouriteList() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_table);
    return results.map((value) => RestaurantElement.fromJson(value)).toList();
  }

  /// Search favourite by name from storage
  Future<Map> getFavouriteFromName(String name) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _table,
      where: 'name = ?',
      whereArgs: [name],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  /// Remove favourite from list on database
  Future<void> removeFavourite(String id) async {
    final db = await database;

    await db!.delete(
      _table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
