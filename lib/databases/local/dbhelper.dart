import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite/sqlite_api.dart';
import 'package:user_database/constants/strings.dart';
import 'package:user_database/models/user.dart';

class Dbhelper {
  Dbhelper._();
  static Dbhelper instance = Dbhelper._();
  Database? db;

  Future<Database?> getDb() async {
    db ??= await openDb();
    return db;
  }

  Future<Database?> openDb() async {
    Directory dir = await getApplicationDocumentsDirectory();

    String path = join(dir.path, "user.db");
    db = await openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(
          "create table $TABLE_NAME($COLUMN_ID integer primary key autoincrement, $COLUMN_NAME text not null, $COLUMN_AGE text not null, $COLUMN_EMAIL text not null, $COLUMN_ADDRESS text not null, $COLUMN_PHONE text not null)",
        );
      },
      version: 1,
    );
    return db;
  }

  Future<bool> addUser(User user) async {
    var db = await getDb();
    int check = await db!.insert(TABLE_NAME, {
      COLUMN_NAME: user.name,
      COLUMN_AGE: user.age,
      COLUMN_EMAIL: user.email,
      COLUMN_ADDRESS: user.address,
      COLUMN_PHONE: user.phoneNo,
    });
    return check > 0;
  }

  Future<List<User>> getUser() async {
    var db = await getDb();
    List<Map<String, dynamic>> users = await db!.query(TABLE_NAME);
    List<User> userList = users.map((e) => User.fromMap(e)).toList();
    return userList;
  }

  Future<bool> updateUser(User user, int id) async {
    Database? db = await getDb();
    int check = await db!.update(
      TABLE_NAME,
      {
        COLUMN_NAME: user.name,
        COLUMN_AGE: user.age,
        COLUMN_EMAIL: user.email,
        COLUMN_ADDRESS: user.address,
        COLUMN_PHONE: user.phoneNo,
      },
      where: "$COLUMN_ID=?",
      whereArgs: [id],
    );
    return check > 0;
  }

  Future<bool> deleteUser(int id) async {
    Database? db = await getDb();
    int check = await db!.delete(
      TABLE_NAME,
      where: "$COLUMN_ID=?",
      whereArgs: [id],
    );
    return check > 0;
  }

  Future<bool> deleteAllUser() async {
    Database? db = await getDb();
    int check = await db!.delete(TABLE_NAME);
    return check > 0;
  }
}
