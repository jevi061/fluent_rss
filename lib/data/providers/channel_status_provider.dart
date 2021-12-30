import 'package:fluent_rss/assets/constants.dart';
import 'package:fluent_rss/data/domains/channel_status.dart';
import 'package:fluent_rss/data/providers/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class ChannelStatusProvider {
  final DatabaseProvider dbProvider = DatabaseProvider.dbProvider;
  // correct read and unread status based on articles data
  Future<void> correctReadStatus(String link) async {
    Database? db = await dbProvider.database;
    await db?.rawInsert(""" insert or replace into channelStatus 
    (channelLink,lastCheck,unreadCount,totalCount)
    values (
      ?,
      select lastCheck from channelStatus 
          where channelLink = ?,
      select count(*) from 
          article left join articleStatus
          on article.uuid = articleStatus.articleId
          where article.channel = ?
          and articleStatus.read = 0,
      select count(*) from 
          article 
          where article.channel = ?  
     )
    """, [link, link, link, link]);
  }

// update all status of channel,should be called after channel changed
  Future<void> updateReadStatus(String link) async {
    var checkedAt = DateTime.now().millisecondsSinceEpoch;
    Database? db = await dbProvider.database;
    await db?.rawUpdate(""" insert or replace into channelStatus 
    (channelLink,lastCheck,unreadCount,totalCount)
    values (
      ?,
      ?,
      (select count(*) from 
          article left join articleStatus
          on article.uuid = articleStatus.articleId
          where article.channel = ?
          and articleStatus.read = 0),
      (select count(*) from 
          article 
          where article.channel = ?  )
     )
    """, [link, checkedAt, link, link]);
  }

  Future<ChannelStatus?> queryChannelStatusByLink(String link) async {
    Database? db = await dbProvider.database;
    var list = await db?.query(TableNameConstants.channelStatus,
        columns: ["channelLink", "lastCheck", "unreadCount", "totalCount"],
        where: "channelLink = ?",
        whereArgs: [link]);
    if (list == null || list.isEmpty) {
      return null;
    }
    return ChannelStatus.fromMap(list.first);
  }
}
