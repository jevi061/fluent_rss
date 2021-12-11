import 'package:fluent_rss/assets/constants.dart';
import 'package:fluent_rss/data/providers/database_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class ArticleStatusProvider {
  final DatabaseProvider dbProvider = DatabaseProvider.dbProvider;

  Future<void> insert(Map<String, dynamic> data) async {
    Database? db = await dbProvider.database;
    db?.insert(TableNameConstants.articleStatus, data,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> batchInsert(List<Map<String, dynamic>> data) async {
    Database? db = await dbProvider.database;
    Batch? batch = db?.batch();
    for (var row in data) {
      batch?.insert(TableNameConstants.articleStatus, row,
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    batch?.commit();
  }

  Future<List<Map<String, dynamic>>?> queryAll() async {
    Database? db = await dbProvider.database;
    return db?.query(TableNameConstants.article, columns: [
      "uuid",
      "title",
      "link",
      "subtitle",
      "channel",
      "published",
      "starred",
      "read"
    ]);
  }

  Future<void> updateReadStatus(String articleId, int read) async {
    Database? db = await dbProvider.database;
    Map<String, dynamic> data = {'read': read};
    db?.update(TableNameConstants.articleStatus, data,
        where: 'articleId = ?', whereArgs: [articleId]);
  }

  Future<void> updateStarStatus(String articleId, int starred) async {
    Database? db = await dbProvider.database;
    Map<String, dynamic> data = {'starred': starred};
    db?.update(TableNameConstants.articleStatus, data,
        where: 'articleId = ?', whereArgs: [articleId]);
  }
}
