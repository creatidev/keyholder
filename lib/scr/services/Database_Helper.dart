import 'package:digitalkeyholder/scr/models/model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

abstract class DatabaseHelper {
  static Database? _db;

  static int get _version => 1;

  static final _categoryTableName = 'categorytable';
  static final columnCategoryId = 'id';
  static final columnCategoryLabel = 'category';

  static final _keycodeTableName = 'keycodetable';
  static final columnKeycodeId = 'id';
  static final columnKeycodeCategory = 'name';
  static final columnKeycodeLabel = 'label';
  static final columnKeycodeIpAddress = 'ip';
  static final columnKeycodeUserName = 'user';
  static final columnKeycodeChain = 'password';
  static final columnKeycodePort = 'port';
  static final columnKeycodeInstace = 'instance';
  static final columnKeycodeRegDate = 'regdate';
  static final columnKeyLastIdAction = 'action';
  static final columnKeycodeUses = 'uses';

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      var databasesPath = await getDatabasesPath();
      final _path = p.join(databasesPath, 'crud.db');
      print(_path);
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_categoryTableName(
      $columnCategoryId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnCategoryLabel STRING
      )
      ''');
    //Batch batch = db.batch();
/*    await db.transaction((txn) async {
      await txn.rawInsert(
          '''INSERT INTO $_categoryTableName ($columnCategoryId, $columnCategoryLabel) VALUES (0,'VPN'),(1,'Pasarela'),(2,'Servidor')''');
    });*/
    await db.execute('''
      CREATE TABLE $_keycodeTableName(
      $columnKeycodeId INTEGER PRIMARY KEY AUTOINCREMENT, 
      $columnKeycodeCategory STRING,
      $columnKeycodeLabel STRING,
      $columnKeycodeIpAddress STRING,
      $columnKeycodeUserName STRING,
      $columnKeycodeChain STRING,
      $columnKeycodePort STRING,
      $columnKeycodeInstace STRING,
      $columnKeycodeRegDate STRING,
      $columnKeyLastIdAction INTEGER,
      $columnKeycodeUses INTEGER
      )
      ''');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db!.query(table);

  static Future<List<Map<String, dynamic>>> qQuery(
      String table, String columns, String where, Model model) async {
    return await _db!.query(table,
        columns: [columns], where: 'id = ?', whereArgs: [model.id]);
  }

  static Future<List<Map<String, dynamic>>> rawQuery(sql) async {
    return await _db!.rawQuery(sql);
  }

  static Future<int> insert(String table, Model model) async =>
      await _db!.insert(table, model.toMap());

  static Future<int> update(String table, Model model) async => await _db!
      .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async =>
      await _db!.delete(table, where: 'id = ?', whereArgs: [model.id]);

  static Future<Batch> batch() async => _db!.batch();
}
