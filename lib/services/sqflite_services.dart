import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:water_plant/helper/show_snackbar.dart';
import 'package:water_plant/model/consumer_model.dart';
import 'package:water_plant/model/user_model.dart';
import 'package:water_plant/screens/auth/login_screen.dart';
import 'package:water_plant/screens/home_screen.dart';

class SqfliteServices {
  Database? db;

  Future<Database?> getDatabase() async {
    if (db != null) return db;

    db = await initDatabase();
    return db;
  }

  Future<Database> initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    var path = join(dir.path, 'users.db');
    var db = openDatabase(path, version: 1, onCreate: onCreate);
    return db;
  }

  delete() async {
    final dir = await getApplicationDocumentsDirectory();
    var path = join(dir.path, 'users.db');
    await deleteDatabase(path);
    print('Database Deleted Successfully');
  }

  Future<void> checkExistTable() async {
    final database = await getDatabase(); // make sure DB is initialized

    // Use rawQuery to check if table exists
    final result = await database!.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='consumers';",
    );

    if (result.isNotEmpty) {
      print('Table "consumers" exists: $result');
    } else {
      print('Table "consumers" does NOT exist');
    }
  }

  onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE users (userID INTEGER PRIMARY KEY, name TEXT,business TEXT,email TEXT,phone TEXT,location TEXT, password TEXT,pincode TEXT,isLoggedIn INTEGER DEFAULT 0)',
    );
    await db.execute('''
  CREATE TABLE consumers (
    consumer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    phone_1 TEXT,
    phone_2 TEXT,
    address TEXT,
    advance INTEGER,
    price INTEGER,
    bottles INTEGER,
    total_amount INTEGER,
    days TEXT
  )
''');
    await db.execute(
      "INSERT INTO sqlite_sequence (name, seq) VALUES ('consumers', 119)",
    );
  }

  Future<UserModel?> register({
    required UserModel userModel,
    required BuildContext context,
  }) async {
    try {
      final database = await getDatabase();
      final id = await database!.insert('users', userModel.toJson());
      print('User is ${userModel.toJson()} and id $id');
      userModel.userID = id;
      print('id ${userModel.userID}');
      showSnackBar(message: "User Registered Successfully", context: context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      showSnackBar(message: e.toString(), context: context);
      return null;
    }
    return userModel;
  }

  Future<UserModel?> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final database = await getDatabase();
      final dbClient = database!;

      final List<Map<String, dynamic>> result = await dbClient.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email.trim(), password.trim()],
      );

      if (result.isNotEmpty) {
        final user = UserModel.fromJson(result.first);
        await dbClient.update(
          'users',
          {'isLoggedIn': 1},
          where: 'userID = ?',
          whereArgs: [user.userID],
        );
        showSnackBar(message: "Login Successful!", context: context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

        return user;
      } else {
        showSnackBar(message: "Invalid Email or Password", context: context);
        return null;
      }
    } catch (e) {
      showSnackBar(message: e.toString(), context: context);
      return null;
    }
  }

  Future<void> deleteData() async {
    final dir = await getApplicationDocumentsDirectory();
    var path = join(dir.path, 'users.db');
    await deleteDatabase(path);
    print('Database deleted successfully!');
  }

  Future<UserModel?> getLoggedInUser() async {
    final db = await getDatabase();
    final result = await db!.query(
      'users',
      where: 'isLoggedIn = ?',
      whereArgs: [1],
    );

    if (result.isNotEmpty) {
      return UserModel.fromJson(result.first);
    }
    return null;
  }

  Future<UserModel?> registerUserWithPin({
    required String pinCode,
    required BuildContext context,
  }) async {
    try {
      final database = await getDatabase();

      // Create user model
      UserModel newUser = UserModel(
        name: '',
        email: "",
        pinCode: pinCode,
        business: '',
        password: '',
        location: '',
        phone: '',
        isLoggedIn: 1,
      );

      // Insert into database
      int id = await database!.insert(
        'users',
        newUser.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      newUser.userID = id;
      newUser.copyWith(id: id);
      print("User registered with ID: $id and ${newUser.userID}");

      showSnackBar(message: "User Registered Successfully", context: context);

      // Navigate to login or home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

      return newUser;
    } catch (e) {
      showSnackBar(
        message: "Registration failed: ${e.toString()}",
        context: context,
      );
      return null;
    }
  }

  Future<ConsumerModel> consumerInfo({
    required ConsumerModel consumerModel,
    required BuildContext context,
  }) async {
    try {
      final db = await getDatabase();

      int id = await db!.insert('consumers', consumerModel.toJson());

      print('Id is $id');
      consumerModel.consumerId = id;
      print('Consumer is ${consumerModel.toJson()}');
      showSnackBar(message: "Data Added Successfully", context: context);

      return consumerModel;
    } catch (e) {
      showSnackBar(message: e.toString(), context: context);
      print('Error ${e.toString()}');
    }
    return consumerModel;
  }

  Future<List<ConsumerModel>> fetchConsumerData() async {
    final db = await getDatabase();

    List<Map<String, dynamic>> consumerData = await db!.rawQuery(
      'SELECT * from consumers',
    );

    List<ConsumerModel> consumerDatalList = consumerData.map((row) {
      return ConsumerModel.fromJson(row);
    }).toList();
    print("Consumer ${consumerDatalList[0].name}");
   return consumerDatalList;
  }
  
}
