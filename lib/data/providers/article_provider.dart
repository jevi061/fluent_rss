import 'package:fluent_rss/assets/constants.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/providers/database_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class ArticleProvider {
  final DatabaseProvider dbProvider = DatabaseProvider.dbProvider;
  static const articleColums = [
    'uuid',
    'channel',
    'link',
    'title',
    'published',
    'subtitle'
  ];

  Future<int> insert(Article article) async {
    Database? db = await dbProvider.database;
    if (db != null) {
      return await db.insert(TableNameConstants.article, article.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    return 0;
  }

  Future<void> batchInsert(List<Article> articles) async {
    Database? db = await dbProvider.database;
    Batch? batch = db?.batch();
    for (var article in articles) {
      batch?.insert(TableNameConstants.article, article.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch?.commit();
  }

  Future<List<Article>> queryAll() async {
    Database? db = await dbProvider.database;
    // query article core data
    var list =
        await db?.query(TableNameConstants.article, columns: articleColums);
    return list?.map((e) => Article.fromMap(e)).toList() ?? [];
  }

  Future<List<Article>> queryPage(int start, int limit) async {
    Database? db = await dbProvider.database;
    // query article core data
    var list = await db?.query(TableNameConstants.article,
        columns: articleColums, limit: limit, offset: start);
    return list?.map((e) => Article.fromMap(e)).toList() ?? [];
  }

  Future<List<Article>> queryByChannelLink(String link) async {
    Database? db = await dbProvider.database;
    var list = await db?.query(TableNameConstants.article,
        columns: articleColums,
        where: "channel = ?",
        whereArgs: [link],
        orderBy: "published desc");
    if (list == null) {
      return [];
    }
    return list.map((e) => Article.fromMap(e)).toList();
  }

  Future<Article?> queryById(String id) async {
    Database? db = await dbProvider.database;
    var list = await db?.query(
      TableNameConstants.article,
      columns: articleColums,
      where: "uuid = ?",
      whereArgs: [id],
    );
    if (list == null) {
      return null;
    }
    return list.map((e) => Article.fromMap(e)).toList().first;
  }

  Future<List<Article>> queryTimeAfter(int timestamp) async {
    Database? db = await dbProvider.database;
    var list = await db?.query(TableNameConstants.article,
        columns: articleColums,
        where: "published > ?",
        whereArgs: [timestamp],
        orderBy: "published desc");
    if (list == null) {
      return [];
    }
    return list.map((e) => Article.fromMap(e)).toList();
  }

  Future<List<Article>> queryPageTimeAfter(
      int timestamp, int start, int limit) async {
    Database? db = await dbProvider.database;
    var list = await db?.query(TableNameConstants.article,
        columns: articleColums,
        where: "published > ?",
        whereArgs: [timestamp],
        orderBy: "published desc",
        limit: limit,
        offset: start);
    if (list == null) {
      return [];
    }
    return list.map((e) => Article.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>?> queryByRead(int read) async {
    Database? db = await dbProvider.database;
    return await db?.rawQuery(
        '''select a.uuid,a.title,a.subtitle,a.link,a.channel,a.published,s.read,s.starred 
        from article as a inner join articleStatus as s 
        on a.uuid = s.articleId
        where s.read = ?
        order by a.published desc''', [read]);
  }

  Future<List<Map<String, dynamic>>?> queryByStar(int starred) async {
    Database? db = await dbProvider.database;
    return await db?.rawQuery(
        '''select a.uuid,a.title,a.subtitle,a.link,a.channel,a.published,s.read,s.starred 
        from article as a inner join articleStatus as s 
        on a.uuid = s.articleId
        where s.starred = ?
        order by a.published desc''', [starred]);
  }

  Future<List<Article>> searchArticles(String query) async {
    Database? db = await dbProvider.database;
    // query article core data
    var list = await db?.query(TableNameConstants.article,
        columns: articleColums, where: "title like ?", whereArgs: ["%$query%"]);
    return list?.map((e) => Article.fromMap(e)).toList() ?? [];
  }

  Future<List<Article>> searchArticlesPrefix(String query) async {
    if (query.isEmpty) {
      return [];
    }
    Database? db = await dbProvider.database;
    // query article core data
    var list = await db?.query(TableNameConstants.article,
        columns: articleColums, where: "title like ?", whereArgs: ["$query%"]);
    return list?.map((e) => Article.fromMap(e)).toList() ?? [];
  }
}
