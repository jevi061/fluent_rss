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

  Future<sql.Database> createDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    Logger().d('db path is:$dbPath');
    return await sql.openDatabase(path.join(dbPath, "rss.db"),
        onCreate: (db, version) {
      db.execute(TableDefinitionConstants.channelTable);
      db.execute(TableDefinitionConstants.articleTable);
      db.execute(TableDefinitionConstants.favoriteTable);
      db.execute(TableDefinitionConstants.historyTable);
    }, version: 10);
  }
}
