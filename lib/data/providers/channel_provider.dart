import 'package:fluent_rss/assets/constants.dart';
import 'package:fluent_rss/data/domains/channel_status.dart';
import 'package:fluent_rss/data/providers/database_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

class ChannelProvider {
  final DatabaseProvider dbProvider = DatabaseProvider.dbProvider;
  ChannelProvider();

  Future<void> insert(Map<String, dynamic> data) async {
    Database? db = await dbProvider.database;
    var channelLink = data['link'];
    var unreadCount = data['unreadCount'];
    var totalCount = data['totalCount'];
    var lastCheck = data['lastCheck'];
    data
      ..remove('lastCheck')
      ..remove('unreadCount')
      ..remove('totalCount');
    var channelStatus = ChannelStatus(
        channelLink: channelLink,
        totalCount: totalCount,
        unreadCount: unreadCount,
        lastCheck: lastCheck);
    Batch? batch = db?.batch();
    batch?.insert(TableNameConstants.channel, data,
        conflictAlgorithm: ConflictAlgorithm.ignore);
    batch?.insert(TableNameConstants.channelStatus, channelStatus.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    await batch?.commit();
  }

  Future<void> batchInsert(List<Map<String, dynamic>> data) async {
    Database? db = await dbProvider.database;
    Batch? batch = db?.batch();
    for (var row in data) {
      var channelLink = row['link'];
      var unreadCount = row['unreadCount'];
      var totalCount = row['totalCount'];
      var lastCheck = row['lastCheck'];
      row
        ..remove('lastCheck')
        ..remove('unreadCount')
        ..remove('totalCount');
      var channelStatus = ChannelStatus(
          channelLink: channelLink,
          totalCount: totalCount,
          unreadCount: unreadCount,
          lastCheck: lastCheck);
      batch?.insert(TableNameConstants.channel, row,
          conflictAlgorithm: ConflictAlgorithm.ignore);
      batch?.insert(TableNameConstants.channelStatus, channelStatus.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch?.commit();
  }

// channelStatus is exist immediately,after channel created.
  Future<void> updateSyncTime(String link, int time) async {
    Database? db = await dbProvider.database;
    Map<String, Object?> data = {"lastCheck": time};
    await db?.update(TableNameConstants.channel, data,
        where: "link=?", whereArgs: [link]);
  }

  Future<List<Map<String, dynamic>>?> query() async {
    Database? db = await dbProvider.database;
    return await db?.rawQuery(
        '''select c.link,c.title,c.description,c.iconUrl,c.directory,c.type,c.version,s.unreadCount,s.totalCount,s.lastCheck
        from channel as c inner join channelStatus as s 
        on c.link = s.channelLink''');
  }

  Future<Map<String, dynamic>> queryByLink(String link) async {
    Database? db = await dbProvider.database;
    var list = await db?.rawQuery(
        '''select c.link,c.title,c.description,c.iconUrl,c.directory,c.type,c.version,s.unreadCount,s.totalCount,s.lastCheck
        from channel as c inner join channelStatus as s 
        on c.link = s.channelLink
        where c.link = ?''', [link]);
    if (list != null) {
      return list.first;
    }
    return Map.fromEntries([]);
  }

  Future<void> deleteByLink(String link) async {
    Database? db = await dbProvider.database;
    await db?.delete(TableNameConstants.channel,
        where: 'link=?', whereArgs: [link]);
  }

  Future<void> updateReadStatus(String link) async {
    Database? db = await dbProvider.database;
    db?.rawUpdate(""" update channelStatus 
    set unreadCount = (
      select count(*) from 
      article left join articleStatus
      on article.uuid = articleStatus.articleId
      where article.channel = ?
      and articleStatus.read = 0 )
    where channelLink = ? 
    """, [link, link]);
    db?.rawUpdate(""" update channelStatus 
    set totalCount = (
      select count(*) from 
      article left join articleStatus
      on article.uuid = articleStatus.articleId
      where article.channel = ?
      )
    where channelLink = ? 
    """, [link, link]);
  }

  Future<void> minusOneUnread(String channel) async {
    Database? db = await dbProvider.database;
    await db?.rawUpdate(""" update channelStatus 
      set unreadCount = unreadCount -1 
      where channelLink = ?
    """, [channel]);
  }
}
