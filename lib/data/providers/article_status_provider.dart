import 'package:fluent_rss/assets/constants.dart';
import 'package:fluent_rss/data/domains/article_status.dart';
import 'package:fluent_rss/data/providers/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class ArticleStatusProvider {
  final DatabaseProvider dbProvider = DatabaseProvider.dbProvider;

  static const articleStatusColumns = ['articleId', 'read', 'starred'];
  Future<void> insert(ArticleStatus status) async {
    Database? db = await dbProvider.database;
    await db?.insert(TableNameConstants.articleStatus, status.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> batchInsert(List<ArticleStatus> status) async {
    Database? db = await dbProvider.database;
    Batch? batch = db?.batch();
    for (var row in status) {
      batch?.insert(TableNameConstants.articleStatus, row.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch?.commit();
  }

  Future<List<ArticleStatus>> queryAll() async {
    Database? db = await dbProvider.database;
    var list = await db?.query(TableNameConstants.article,
        columns: articleStatusColumns);
    if (list == null) {
      return [];
    }
    return list.map((e) => ArticleStatus.fromMap(e)).toList();
  }

  Future<ArticleStatus?> queryByArticleId(String articleId) async {
    Database? db = await dbProvider.database;
    var list = await db?.query(TableNameConstants.articleStatus,
        columns: articleStatusColumns,
        where: 'articleId = ?',
        whereArgs: [articleId]);
    if (list == null || list.isEmpty) {
      return null;
    }
    return ArticleStatus.fromMap(list.first);
  }

  Future<void> updateReadStatus(String articleId, int read) async {
    Database? db = await dbProvider.database;
    Map<String, dynamic> data = {'read': read};
    await db?.update(TableNameConstants.articleStatus, data,
        where: 'articleId = ?', whereArgs: [articleId]);
    await db?.rawInsert('''insert or replace into articleStatus 
    (articleId,read,starred) 
    values(?,?,0)''', [articleId, read]);
  }

  Future<void> updateStarStatus(String articleId, int starred) async {
    Database? db = await dbProvider.database;
    var data = {"starred": 1};
    await db?.insert(TableNameConstants.articleStatus, data,
        conflictAlgorithm: ConflictAlgorithm.ignore);
    await db?.rawInsert('''insert or replace into articleStatus 
    (articleId,read,starred) 
    values(?,0,?)''', [articleId, starred]);
  }
}
