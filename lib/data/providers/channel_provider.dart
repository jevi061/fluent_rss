import 'package:fluent_rss/assets/constants.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/providers/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class ChannelProvider {
  final DatabaseProvider dbProvider = DatabaseProvider.dbProvider;
  ChannelProvider();

  Future<void> insert(Channel channel) async {
    // attach category to channel
    var data = channel.toMap();
    Database? db = await dbProvider.database;
    await db?.insert(TableNameConstants.channel, data,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> batchInsert(List<Channel> channels) async {
    Database? db = await dbProvider.database;
    Batch? batch = db?.batch();
    for (var channel in channels) {
      var data = channel.toMap();
      // attach category to channel
      batch?.insert(TableNameConstants.channel, data,
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
    await batch?.commit();
  }

// channelStatus is exist immediately,after channel created.
  // Future<void> updateSyncTime(String link, int time) async {
  //   Database? db = await dbProvider.database;
  //   Map<String, Object?> data = {"lastCheck": time};
  //   await db?.insert(TableNameConstants.channel, data,
  //       where: "link=?", whereArgs: [link]);
  // }

  Future<List<Channel>> query() async {
    Database? db = await dbProvider.database;
    var list = await db?.query(TableNameConstants.channel, columns: [
      "link",
      "title",
      "description",
      "type",
      "version",
      "iconUrl",
      "categoryId"
    ]);
    return list?.map((e) => Channel.fromMap(e)).toList() ?? [];
  }

  Future<Channel?> queryByLink(String link) async {
    Database? db = await dbProvider.database;
    var list = await db?.query(TableNameConstants.channel,
        columns: ["link", "title", "description", "type", "version", "iconUrl"],
        where: "link = ?",
        whereArgs: [link]);
    return list?.first == null ? null : Channel.fromMap(list!.first);
  }

  Future<List<Channel>> queryByCategoryId(int categoryId) async {
    Database? db = await dbProvider.database;
    var list = await db?.query(TableNameConstants.channel,
        columns: [
          "link",
          "title",
          "description",
          "type",
          "version",
          "iconUrl",
          "categoryId"
        ],
        where: "categoryId = ?",
        whereArgs: [categoryId]);
    return list?.map((e) => Channel.fromMap(e)).toList() ?? [];
  }

  Future<void> deleteByLink(String link) async {
    Database? db = await dbProvider.database;
    await db?.delete(TableNameConstants.channel,
        where: 'link=?', whereArgs: [link]);
  }

  Future<void> decreaseUnread(String link) async {
    Database? db = await dbProvider.database;
    await db?.rawUpdate(""" update channelStatus 
      set unreadCount = unreadCount -1 
      where channelLink = ?
    """, [link]);
  }

  Future<void> changeCategory(Channel channel, int categoryId) async {
    Database? db = await dbProvider.database;
    await db?.update(TableNameConstants.channel, {"categoryId": categoryId},
        where: "link=?", whereArgs: [channel.link]);
  }

  Future<List<Channel>> searchChannels(String query) async {
    Database? db = await dbProvider.database;
    var list = await db?.query(
      TableNameConstants.channel,
      columns: [
        "link",
        "title",
        "description",
        "type",
        "version",
        "iconUrl",
        "categoryId"
      ],
      where: 'title like ?',
      whereArgs: ['%$query%'],
    );
    return list?.map((e) => Channel.fromMap(e)).toList() ?? [];
  }

  Future<List<Channel>> searchChannelPrefix(String query) async {
    Database? db = await dbProvider.database;
    var list = await db?.query(
      TableNameConstants.channel,
      columns: [
        "link",
        "title",
        "description",
        "type",
        "version",
        "iconUrl",
        "categoryId"
      ],
      where: 'title like ?',
      whereArgs: ['$query%'],
    );
    return list?.map((e) => Channel.fromMap(e)).toList() ?? [];
  }
}
