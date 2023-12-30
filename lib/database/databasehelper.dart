import 'package:restaurant_with_api/database/db_model_restaurants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static late Database _database;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  Future<Database> get database async {
    _database = await _initializeDb();
    return _database;
  }

  static const String _tableName = 'restaurants';
  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'restaurantsDb.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableName (
               id CHAR PRIMARY KEY,
               name TEXT, desc TEXT , picId TEXT , kota TEXT , rating TEXT , fav TEXT
             )''',
        );
      },
      version: 1,
    );
    return db;
  }

  Future<void> insertRestaurants(DbRestaurants restaurants) async {
    final Database db = await database;
    await db.insert(_tableName, restaurants.toMap());
    print('Data saved');
  }

  Future<List<DbRestaurants>> getRestaurants() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);

    return results.map((res) => DbRestaurants.fromMap(res)).toList();
  }

  Future<DbRestaurants> getRestaurantsId(int id) async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.map((res) => DbRestaurants.fromMap(res)).first;
  }

  Future<List<DbRestaurants>> getRestaurantsFavorite() async {
    final Database db = await database;
    List<Map<String, dynamic>> results =
        await db.query(_tableName, where: 'fav = ?', whereArgs: ['True']);

    return List.generate(results.length, (index) {
      return DbRestaurants.fromMap(results[index]);
    });
  }

  Future<void> updateRestaurants(DbRestaurants note) async {
    final db = await database;

    await db.update(
      _tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<void> deleteRestaurants(String id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    List<Map> maps = await db.query(
      _tableName,
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }
}
