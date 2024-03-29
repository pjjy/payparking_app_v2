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
      CREATE TABLE paypartrans(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plateNumber TEXT,
        dateToday TEXT,
        dateTimeToday TEXT,
        dateUntil TEXT,
        amount TEXT,
        user TEXT,
        status TEXT)''');

    db.execute('''
      CREATE TABLE payparhistory(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plateNumber TEXT,
        dateTimein TEXT,
        dateTimeout TEXT,
        amount TEXT,
        penalty TEXT,
        user TEXT
        )''');

    db.execute('''
      CREATE TABLE synchistory(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        syncDate TEXT
        )''');

    print("Database was created!");
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    // Run migration according database versions
  }

  Future<int> addTrans(String plateNumber, String dateToday, String dateTimeToday, String dateUntil,String amount,String user,int stat) async {
    var client = await db;
    return client.insert('paypartrans', {'plateNumber':plateNumber,'dateToday':dateToday,'dateTimeToday':dateTimeToday,'dateUntil':dateUntil,'amount':amount,'user':user,'status':stat});
  }

  Future<List> fetchAll() async {
    var client = await db;
    return client.query('paypartrans Where status = 1');
    // where status = 1
  }

  Future<List> fetchSync() async{
    var client = await db;
    return client.query('synchistory ORDER BY id DESC LIMIT 1');
  }

  Future<int> insertSyncDate(String date) async{
    var client = await db;
    return client.insert('synchistory', {'syncDate':date});
  }


  Future<List> fetchAllHistory() async {
    var client = await db;
//    return client.query('payparhistory ORDER BY id DESC');
    var res = await client.query('payparhistory ORDER BY id DESC');
    if (res.isNotEmpty) {
      return client.query('payparhistory ORDER BY id DESC');
    }
    else{
      return [];
    }
  }

//  fetchAllHistoryCount() async{
//    int count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM table_name'));
//
//    var client = await db;
//    return client.query('synchistory ORDER BY id DESC LIMIT 1');
//  }

  Future<int> addTransHistory(String plateNumber,String dateIn,String dateNow,String amountPay,String penalty,String user) async {
    var client = await db;
    return client.insert('payparhistory', {'plateNumber':plateNumber,'dateTimein':dateIn,'dateTimeout':dateNow,'amount':amountPay,'penalty':penalty,'user':user});
  }



  Future<int> updatePayTranStat(int id) async{
    var client = await db;
    return client.update('paypartrans', {'status': '0'}, where: 'id = ?', whereArgs: [id]);
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
