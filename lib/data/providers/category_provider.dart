import 'package:fluent_rss/assets/constants.dart';
import 'package:fluent_rss/data/domains/category.dart';
import 'package:fluent_rss/data/providers/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class CategoryProvider {
  final DatabaseProvider dbProvider = DatabaseProvider.dbProvider;

  Future<int?> insert(Category category) async {
    Database? db = await dbProvider.database;
    return await db?.insert(TableNameConstants.category, category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> batchInsert(List<Category> categories) async {
    Database? db = await dbProvider.database;
    Batch? batch = db?.batch();
    for (var category in categories) {
      batch?.insert(TableNameConstants.category, category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch?.commit();
  }

  Future<List<Category>> queryAll() async {
    Database? db = await dbProvider.database;
    var list =
        await db?.query(TableNameConstants.category, columns: ["id", "name"]);
    if (list == null) {
      return [];
    }
    return list.map((e) => Category.fromMap(e)).toList();
  }

  Future<Category?> queryById(int categoryId) async {
    Database? db = await dbProvider.database;
    var list = await db?.query(TableNameConstants.category,
        columns: ["id", "name"], where: "id = ?", whereArgs: [categoryId]);
    if (list == null || list.isEmpty) {
      return null;
    }
    return Category.fromMap(list.first);
  }

  Future<void> deleteCategory(int id) async {
    Database? db = await dbProvider.database;
    await db
        ?.delete(TableNameConstants.category, where: "id = ?", whereArgs: [id]);
  }
}
