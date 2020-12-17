import 'package:refactory_test/model/user-model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class DbHelper {
  static final DbHelper instance = DbHelper.internal();
  DbHelper.internal();

  factory DbHelper() => instance;

  static Database db;

  Future<Database> get database async{
    if(db != null) return db;
    db = await setDatabase();
    return db;
  }

  setDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "user");
    var database = await openDatabase(path, version: 1, onCreate: onCreateDatabase);
    return database;
  }

  void onCreateDatabase(Database db, int version) async {
    await db.execute("CREATE TABLE auth(id INTEGER PRIMARY KEY, username VARCHAR(40), email TEXT, password VARCHAR(50), counter INTEGER)");
    print("Database Created");
  }

  Future<int> saveUserData(UserModel userModel) async {
    var dbClient = await database;
    int res = await dbClient.insert("auth", userModel.toMap());
    print("data inserted");
    return res;
  }

  Future getEmailCounter(String email) async {
    var dbClient = await database;
    var res = await dbClient.rawQuery("SELECT email, counter FROM auth WHERE email = ? GROUP BY email", [email]);
    if(res.isEmpty){
      res = null;
    }else{
      print("EmailCounter : $res");
    }
    return res;
  }
  Future setCounter(int counter, String email) async {
    var dbClient = await database;
    int res = await dbClient.rawUpdate("UPDATE auth SET counter = ? WHERE email = ?", [counter, email]);
    print("updated count : $res");
    return res;
  }
  Future getUser(String email) async {
    var dbClient = await database;
    var res = await dbClient.rawQuery("SELECT email FROM auth WHERE email = '$email'");
    print("Email : ${res[0]['email']}");
    return res;
  }

  Future loginUser(String email, String password) async {
    var dbClient = await database;
    var res = await dbClient.rawQuery("SELECT email, password FROM auth WHERE email = ? AND password = ?", [email, password]);
    print("Login => $res");
    return res;
  }
}