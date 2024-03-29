import 'package:fluent_rss/assets/constants.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  sql.Database? _db;

  Future<sql.Database?> get database async {
    if (_db != null) {
      return _db;
    }
    return await createDatabase();
  }

  Future<sql.Database?> createDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    Logger().d('db path is:$dbPath');
    _db = await sql.openDatabase(path.join(dbPath, DatabaseConstants.database),
        onConfigure: (db) {
      db.execute('PRAGMA foreign_keys = ON');
    }, onCreate: (db, version) {
      db.execute(TableDefinitionConstants.categoryTable);
      // create default `all` category
      db.insert(TableNameConstants.category, {"name": "all"},
          conflictAlgorithm: sql.ConflictAlgorithm.ignore);
      db.execute(TableDefinitionConstants.channelTable);
      db.execute(TableDefinitionConstants.channelStatusTable);
      db.execute(TableDefinitionConstants.articleTable);
      db.execute(TableDefinitionConstants.articleStatusTable);
    }, version: DatabaseConstants.version);
    return _db;
  }
}
