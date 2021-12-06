import 'package:fluent_rss/data/providers/database_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class ChannelProvider {
  final DatabaseProvider dbProvider = DatabaseProvider.dbProvider;
  ChannelProvider();

  Future<void> insert(Map<String, dynamic> data) async {
    Database? db = await dbProvider.database;
    db?.insert('channel', data, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> batchInsert(List<Map<String, dynamic>> data) async {
    Database? db = await dbProvider.database;
    Batch? batch = db?.batch();
    Logger().d('${data.length} channels to insert');
    for (var row in data) {
      batch?.insert('channel', row,
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    batch?.commit();
  }

  Future<List<Map<String, dynamic>>?> query() async {
    Database? db = await dbProvider.database;
    return db?.query('channel',
        columns: ["title", "link", "description", "type", "version", "icon"]);
  }
}
