import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class PayParkingDatabase {
  static final PayParkingDatabase _instance = PayParkingDatabase._();
  static Database _database;

  PayParkingDatabase._();

  factory PayParkingDatabase() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database;
    }

    _database = await init();

    return _database;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'payparking.db');
    var database = openDatabase(dbPath, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);

    return database;
  }

  void _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE payparking(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plate_number TEXT,
        dateToday TEXT,
        dateTimeToday TEXT,
        dateUntil TEXT,
        amount TEXT)''');
    print("Database was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }

  Future<int> addTrans(String plateNumber, String dateToday, String dateTimeToday, String dateUntil,String amount) async {
    var client = await db;
    return client.insert('payparking', {'plate_number':plateNumber,'dateToday':dateToday,'dateTimeToday':dateTimeToday,'dateUntil':dateUntil,'amount':amount});
  }

  Future<List> fetchAll() async {
    var client = await db;
    return client.query('payparking');
  }



//  Future<Car> fetchCar(int id) async {
//    var client = await db;
//    final Future<List<Map<String, dynamic>>> futureMaps = client.query('car', where: 'id = ?', whereArgs: [id]);
//    var maps = await futureMaps;
//
//    if (maps.length != 0) {
//      return Car.fromDb(maps.first);
//    }
//
//    return null;
//  }
//
//  Future<List<Car>> fetchAll() async {
//    var client = await db;
//    var res = await client.query('car');
//
//    if (res.isNotEmpty) {
//      var cars = res.map((carMap) => Car.fromDb(carMap)).toList();
//      return cars;
//    }
//    return [];
//  }
//
//  Future<int> updateCar(Car newCar) async {
//    var client = await db;
//    return client.update('car', newCar.toMapForDb(),
//        where: 'id = ?', whereArgs: [newCar.id], conflictAlgorithm: ConflictAlgorithm.replace);
//  }
//
//  Future<void> removeCar(int id) async {
//    var client = await db;
//    return client.delete('car', where: 'id = ?', whereArgs: [id]);
//  }
//
//  Future closeDb() async {
//    var client = await db;
//    client.close();
//  }
}
