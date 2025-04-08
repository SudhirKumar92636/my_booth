import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    var dirPath = await getDatabasesPath();
    String path = join(dirPath, "jh16.db");

    if (!await File(path).exists()) {
      ByteData data = await rootBundle.load("assets/jh16.db");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
      print("✅ Database copied successfully!");
    } else {
      print("📁 Database already exists.");
    }
    return await openDatabase(path);
  }



  Future<List<Map<String, dynamic>>> getBoothsData() async {
    final db = await getDatabase();
    var booths = await db.query("booth");
    return booths;
  }

   Future<List<Map<String, dynamic>>> fetchVotersByBooth(int partNo) async {
    final db = await getDatabase();
    print("partno is ::: $partNo");
    return await db.query('Mytable', where: 'partno = ?', whereArgs: [partNo]);
  }

  Future<List<Map<String, dynamic>>> searchVoters(String query) async {
    final dbClient = await getDatabase();

    return await dbClient.rawQuery(
      '''
    SELECT id, name, relative_name, cardno, mobile 
    FROM Mytable 
    WHERE name LIKE ? 
    OR relative_name LIKE ? 
    OR id = ? 
    OR mobile = ?
    ''',
      ['%$query%', '%$query%', query, query],
    );
  }





}
