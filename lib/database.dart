// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import '../../modles/user_modle.dart';
//
// class DataController extends GetxController {
//   var allData = <Map<String, dynamic>>[].obs;
//   Database? myDatabase;
//
//   // Table name
//   static const String tableName = "StudentData";
//   @override
//   void onInit() {
//     super.onInit();
//     getAllData();
//   }
//
//   Future<Database> getDatabase() async {
//     if (myDatabase != null) {
//       return myDatabase!;
//     }
//     myDatabase = await openDb();
//     return myDatabase!;
//   }
//
//   Future<Database> openDb() async {
//     Directory dirPath = await getApplicationDocumentsDirectory();
//     String databasePath = join(dirPath.path, "studentData.db");
//
//     return await openDatabase(
//       databasePath,
//       version: 1,
//       onCreate: (db, version) async {
//         String sql = await rootBundle.loadString('assets/my_database.sql');
//         await db.execute(sql);
//
//         // Create table
//       },
//     );
//   }
//
//
//   Future<void> getAllData() async {
//     var db = await getDatabase();
//     List<Map<String, dynamic>> myData = await db.query(tableName);
//     allData.value = myData;
//   }
//
// }
//




import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataController extends GetxController {
  var allData = <Map<String, dynamic>>[].obs;
  Database? myDatabase;

  // Table name
  static const String tableName = "StudentData";

  @override
  void onInit() {
    super.onInit();
    getAllData();
  }

  Future<Database> getDatabase() async {
    if (myDatabase != null) {
      return myDatabase!;
    }
    myDatabase = await openDb();
    return myDatabase!;
  }

  Future<Database> openDb() async {
    try {
      Directory dirPath = await getApplicationDocumentsDirectory();
      String databasePath = join(dirPath.path, "studentData.db");

      return await openDatabase(
        databasePath,
        version: 1,
        onCreate: (db, version) async {
          try {
            String sql = await rootBundle.loadString('assets/my_database.sql');
            List<String> queries = sql.split(";");

            for (var query in queries) {
              if (query.trim().isNotEmpty) {
                await db.execute(query);
              }
            }
          } catch (e) {
            print("Error executing SQL file: $e");
          }
        },
      );
    } catch (e) {
      print("Database Initialization Error: $e");
      rethrow;
    }
  }

  Future<void> getAllData() async {
    try {
      var db = await getDatabase();
      List<Map<String, dynamic>> myData = await db.query(tableName);
      allData.value = myData.isNotEmpty ? myData : [];
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}
