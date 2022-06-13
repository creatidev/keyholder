import 'package:digitalkeyholder/scr/models/JsonModels/CategoriesModel.dart';
import 'package:digitalkeyholder/scr/services/db_helper.dart';

class DBService {
  int? _length;

  // ignore: unnecessary_getters_setters
  int? get length => _length;

  // ignore: unnecessary_getters_setters
  set length(int? length) {
    _length = length;
  }

  Future<bool> addCategory(Categories model) async {
    await DatabaseHelper.init();
    bool isSaved = false;
    int inserted = await DatabaseHelper.insert(Categories.table, model);

    isSaved = inserted == 1 ? true : false;

    return isSaved;
  }

  Future<bool> addKeycode(Keycode model) async {
    await DatabaseHelper.init();
    bool isSaved = false;
    int inserted = await DatabaseHelper.insert(Keycode.table, model);

    isSaved = inserted == 1 ? true : false;

    return isSaved;
  }

  Future<bool> updateCategory(Categories model) async {
    await DatabaseHelper.init();
    bool isSaved = false;
    int inserted = await DatabaseHelper.update(Categories.table, model);

    isSaved = inserted == 1 ? true : false;

    return isSaved;
  }

  Future<bool> updateKeycode(Keycode model) async {
    await DatabaseHelper.init();
    bool isSaved = false;
    int inserted = await DatabaseHelper.update(Keycode.table, model);

    isSaved = inserted == 1 ? true : false;

    return isSaved;
  }

  Future<List<Categories>> getCategory() async {
    await DatabaseHelper.init();
    List<Map<String, dynamic>> categories =
        await DatabaseHelper.query(Categories.table);

    return categories.map((item) => Categories.fromMap(item)).toList();
  }

  Future<List<Keycode>> getKeycodes() async {
    await DatabaseHelper.init();
    List<Map<String, dynamic>> keycodes =
        await DatabaseHelper.query(Keycode.table);
    length = keycodes.length;
    return keycodes.map((item) => Keycode.fromMap(item)).toList();
  }

  Future<List<Keycode>> getKeycodeById(
      String columns, String where, Keycode model) async {
    await DatabaseHelper.init();
    List<Map<String, dynamic>> keycodes =
        await DatabaseHelper.qQuery(Keycode.table, columns, where, model);

    return keycodes.map((item) => Keycode.fromMap(item)).toList();
  }

  Future<List<Keycode>> getKeycodeByCategory(sql) async {
    await DatabaseHelper.init();
    List<Map<String, dynamic>> keycodes = await DatabaseHelper.rawQuery(sql);
    length = keycodes.length;
    print(keycodes.length);
    return keycodes.map((item) => Keycode.fromMap(item)).toList();
  }

  Future<bool> deleteCategory(Categories model) async {
    await DatabaseHelper.init();
    bool isSaved = false;
    int inserted = await DatabaseHelper.delete(Categories.table, model);

    isSaved = inserted == 1 ? true : false;

    return isSaved;
  }

  Future<bool> deleteKeycode(Keycode model) async {
    await DatabaseHelper.init();
    bool isSaved = false;
    int inserted = await DatabaseHelper.delete(Keycode.table, model);

    isSaved = inserted == 1 ? true : false;

    return isSaved;
  }
}
