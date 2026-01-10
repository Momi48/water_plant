import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:water_plant/helper/show_snackbar.dart';
import 'package:water_plant/model/counter_sale_model.dart';
import 'package:water_plant/model/labour_model.dart';
import 'package:water_plant/model/user_model.dart';
import 'package:water_plant/screens/auth/login_screen.dart';
import 'package:water_plant/screens/home_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:water_plant/model/consumer_model.dart';

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
    var db = await openDatabase(path, version: 1, onCreate: onCreate);
    return db;
  }

  Future<void> delete() async {
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

  Future<void> onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE users (userID INTEGER PRIMARY KEY, name TEXT,business TEXT,email TEXT,phone TEXT,location TEXT, password TEXT,pincode TEXT,isLoggedIn INTEGER DEFAULT 0)',
    );
    await db.execute('''
  CREATE TABLE consumers (
    consumer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    consumer_code TEXT,
    name TEXT,
    phone_1 TEXT,
    phone_2 TEXT,
    address TEXT,
    advance INTEGER,
    price INTEGER,
    bottles INTEGER,
    total_amount INTEGER,
    days TEXT,
    status INTEGER DEFAULT 0
  )
''');
    await db.execute(
      "INSERT INTO sqlite_sequence (name, seq) VALUES ('consumers', 119)",
    );

    await db.execute('''
CREATE TABLE labours (
  labour_id INTEGER PRIMARY KEY AUTOINCREMENT,
  labour_code TEXT UNIQUE,

  name TEXT NOT NULL,
  cnic TEXT NOT NULL,
  mobile_1 TEXT NOT NULL,
  mobile_2 TEXT,
  address TEXT,
  date_of_joining TEXT NOT NULL,
  salary INTEGER,
  commission TEXT,
  status INTEGER DEFAULT 0,
  job_type TEXT NOT NULL CHECK(job_type IN ('salary', 'commission')),
  
  CHECK (
    (job_type = 'salary' AND salary IS NOT NULL)
    OR
    (job_type = 'commission' AND salary IS NULL)
  )
  
);
''');
    await db.execute('''
  CREATE TABLE counter_sale (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    amount INTEGER NOT NULL,
    date TEXT NOT NULL,
    status INTEGER NOT NULL DEFAULT 0
  )
''');
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

      // 1️⃣ Insert without consumer_code
      int id = await db!.insert('consumers', consumerModel.toJson());
      print('Hey');

      String consumerCode = 'C-$id';
      print('Hey 2');

      await db.update(
        'consumers',
        {'consumer_code': consumerCode},
        where: 'consumer_id = ?',
        whereArgs: [id],
      );
      print('Hey 3');
      // 4️⃣ Update model
      consumerModel.consumerId = id;
      consumerModel.consumerCode = consumerCode;

      showSnackBar(
        message: "ConsumersData Added Successfully",
        context: context,
      );

      return consumerModel;
    } catch (e) {
      showSnackBar(message: e.toString(), context: context);
      rethrow;
    }
  }

  Future<void> updateConsumerStatus({
    required int consumerId,
    required int status,
  }) async {
    try {
      final db = await getDatabase();

      await db!.update(
        'consumers',
        {'status': status},
        where: 'consumer_id = ?',
        whereArgs: [consumerId],
      );
    } catch (e) {
      rethrow;
    }
  }

Future<void> editConsumerData({
  required int consumerId,
  required String name,
  required String phone1,
  String? phone2,
  required String address,
  int? advance,
  required int price,
  int? bottles,
  required List<String> days,
  
  BuildContext? context,
}) async {
  try {
    final db = await getDatabase();

    await db!.update(
      'consumers', // your table name
      {
        'name': name,
        'phone_1': phone1,
        'phone_2': phone2,
        'address': address,
        'advance': advance ?? 0,
        'price': price,
        'bottles': bottles ?? 0,
        'days': days.join(','), // store as comma-separated string
        'status': 0,
      },
      where: 'consumer_id = ?',
      whereArgs: [consumerId],
    );

    if (context != null) {
      showSnackBar(message: "Consumer Updated Successfully", context: context);
    }
  } catch (e) {
    rethrow;
  }
}


  Future<List<ConsumerModel>> fetchConsumerData() async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> result = await db!.query(
      'consumers',
      where: 'status = ?',
      whereArgs: [0],
      orderBy: 'consumer_id DESC',
    );

    // Convert to model
    final consumerList = result.map((row) {
      return ConsumerModel.fromJson(row);
    }).toList();

    return consumerList;
  }

  Future<LabourModelData> labourInfo({
    required LabourModelData labourModel,
    required BuildContext context,
  }) async {
    try {
      final db = await getDatabase();

      // 1️⃣ Insert without consumer_code
      int id = await db!.insert('labours', labourModel.toJson());

      // 2️⃣ Generate code
      String labourCode = 'L-00$id';
      print("Labour code $labourCode");
      await db.update(
        'labours',
        {'labour_code': labourCode},
        where: 'labour_id = ?',
        whereArgs: [id],
      );
      print('Hey 3');

      labourModel.labourId = id;
      labourModel.labourCode = labourCode;
      print('Labour Data ${labourModel.toJson()}');
      showSnackBar(message: "Labour Data Added Successfully", context: context);

      return labourModel;
    } catch (e) {
      showSnackBar(message: e.toString(), context: context);
      rethrow;
    }
  }

  Future<void> updateLabourStatus({
    required int labourId,
    required int status,
  }) async {
    try {
      final db = await getDatabase();

      await db!.update(
        'labours',
        {'status': status},
        where: 'labour_id = ?',
        whereArgs: [labourId],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editLabourData({
    required int labourId,
    required String name,
    required String cnic,
    required String mobile1,
    String? mobile2,
    required String address,
    required String dateOfJoining,
    String? jobType,
    int? salary,
    String? commission,
    BuildContext? context
  }) async {
    try {
      final db = await getDatabase();

      await db!.update(
        'labours',
        {
          'name': name,
          'cnic': cnic,
          'mobile_1': mobile1,
          'mobile_2': mobile2,
          'address': address,
          'date_of_joining': dateOfJoining,
          'job_type': jobType,
          'status':0,
          'salary': salary,
          'commission':"0"
          
        },
        where: 'labour_id = ?',
        whereArgs: [labourId],
      );
      showSnackBar(message: "Labour Updated Successfully", context: context!);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LabourModelData>> fetchLabourInfo(BuildContext context) async {
    try {
      final db = await getDatabase();

      final List<Map<String, dynamic>> labourData = await db!.query(
        'labours',
        where: 'status = ?',
        whereArgs: [0],
        orderBy: 'date_of_joining ASC',
      );

      final labourList = labourData.map((row) {
        return LabourModelData.fromJson(row);
      }).toList();

      return labourList;
    } catch (e) {
      showSnackBar(message: e.toString(), context: context);
      return [];
    }
  }

  void counterSaleInfo({
    required CounterSaleModel counterSaleModel,
    required BuildContext context,
  }) async {
    try {
      final db = await getDatabase();
      print("hey");
      int id = await db!.insert(
        'counter_sale',
        counterSaleModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      counterSaleModel.id = id;

      showSnackBar(message: "Counter Sale Data Added", context: context);
    } catch (e) {
      showSnackBar(message: e.toString(), context: context);
    }
  }

  Future<List<CounterSaleModel>> fetchCounterSale({
    required BuildContext context,
  }) async {
    try {
      final db = await getDatabase();

      final result = await db!.query(
        'counter_sale',
        where: 'status = ?',
        whereArgs: [0], //  ONLY ACTIVE RECORDS
        orderBy: 'date ASC',
      );

      return result.map((e) => CounterSaleModel.fromJson(e)).toList();
    } catch (e) {
      print('Error ${e.toString()}');
      return [];
    }
  }

  Future<void> updateCounterSale(
    BuildContext context,
    CounterSaleModel counterSale,
  ) async {
    try {
      final db = await getDatabase();

      await db!.update(
        'counter_sale',
        {'amount': counterSale.amount, 'date': counterSale.date},
        where: 'id = ?',
        whereArgs: [counterSale.id],
      );
      showSnackBar(message: "Data Edited Successfully", context: context);
    } catch (e) {}
  }

  Future<void> softDeleteCounterSale(BuildContext context, int id) async {
    try {
      final db = await getDatabase();

      final data = await db!.update(
        'counter_sale',
        {'status': 1},
        where: 'id = ?',
        whereArgs: [id],
      );

      print('object data $data');
      showSnackBar(message: "Date Deleted", context: context);
    } catch (e) {
      showSnackBar(message: e.toString(), context: context);
    }
  }
}
