import 'package:fluent_rss/data/providers/database_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class HistoryProvider {
  final DatabaseProvider dbProvider = DatabaseProvider.dbProvider;

  Future<void> insert(Map<String, dynamic> data) async {
    Database? db = await dbProvider.database;
    db?.insert('history', data, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> batchInsert(List<Map<String, dynamic>> data) async {
    Database? db = await dbProvider.database;
    Batch? batch = db?.batch();
    Logger().d('${data.length} article(s) to insert');
    for (var row in data) {
      batch?.insert('history', row,
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    batch?.commit();
  }

  Future<List<Map<String, dynamic>>?> queryAll() async {
    Database? db = await dbProvider.database;
    return db?.query('history',
        columns: ["uuid", "title", "link", "subtitle", "channel", "published"]);
  }

  Future<List<Map<String, dynamic>>?> queryByChannelLink(String link) async {
    Database? db = await dbProvider.database;
    return db?.query('history',
        columns: ["uuid", "title", "link", "subtitle", "channel", "published"],
        where: 'channel = ?',
        whereArgs: [link]);
  }

  Future<List<Map<String, dynamic>>?> queryTimeAfter(int timestamp) async {
    Database? db = await dbProvider.database;
    return db?.query('history',
        columns: ["uuid", "title", "link", "subtitle", "channel", "published"],
        where: 'published > ?',
        whereArgs: [timestamp]);
  }
}
