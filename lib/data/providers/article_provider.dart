import 'package:fluent_rss/assets/constants.dart';
import 'package:fluent_rss/data/domains/article_status.dart';
import 'package:fluent_rss/data/providers/database_provider.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class ArticleProvider {
  final DatabaseProvider dbProvider = DatabaseProvider.dbProvider;

  Future<void> insert(Map<String, dynamic> data) async {
    Database? db = await dbProvider.database;
    int read = data['read'];
    int starred = data['starred'];
    data.remove('read');
    data.remove('starred');
    Batch? batch = db?.batch();
    batch?.insert(TableNameConstants.article, data,
        conflictAlgorithm: ConflictAlgorithm.ignore);
    var status =
        ArticleStatus(articleId: data['uuid'], read: read, starred: starred);
    batch?.insert(TableNameConstants.articleStatus, status.toMap());
    await batch?.commit();
  }

  Future<void> batchInsert(List<Map<String, dynamic>> data) async {
    Database? db = await dbProvider.database;
    Batch? batch = db?.batch();
    for (var row in data) {
      int read = row['read'];
      int starred = row['starred'];
      row.remove('read');
      row.remove('starred');
      batch?.insert(TableNameConstants.article, row,
          conflictAlgorithm: ConflictAlgorithm.ignore);
      var status =
          ArticleStatus(articleId: row['uuid'], read: read, starred: starred);
      batch?.insert(TableNameConstants.articleStatus, status.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch?.commit();
  }

  Future<List<Map<String, dynamic>>?> queryAll() async {
    Database? db = await dbProvider.database;
    return await db?.rawQuery(
        '''select a.uuid,a.title,a.subtitle,a.link,a.channel,a.published,s.read,s.starred 
        from article as a inner join articleStatus as s 
        on a.uuid = s.articleId''');
  }

  Future<List<Map<String, dynamic>>?> queryByChannelLink(String link) async {
    Database? db = await dbProvider.database;
    Logger().d('query articles from:$link');
    return await db?.rawQuery(
        '''select a.uuid,a.title,a.subtitle,a.link,a.channel,a.published,s.read,s.starred 
        from article as a inner join articleStatus as s 
        on a.uuid = s.articleId
        where a.channel = ? 
        order by a.published desc''', [link]);
  }

  Future<List<Map<String, dynamic>>?> queryTimeAfter(int timestamp) async {
    Database? db = await dbProvider.database;
    return await db?.rawQuery(
        '''select a.uuid,a.title,a.subtitle,a.link,a.channel,a.published,s.read,s.starred 
        from article as a inner join articleStatus as s 
        on a.uuid = s.articleId
        where a.published > ?
        order by a.published desc''', [timestamp]);
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
}
