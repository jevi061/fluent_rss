import 'package:fluent_rss/assets/constants.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/providers/article_provider.dart';
import 'package:fluent_rss/data/providers/channel_provider.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:fluent_rss/services/feed_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class ChannelRepository {
  ChannelProvider channelProvider;
  ArticleProvider articleProvider;
  ChannelRepository(
      {required this.channelProvider, required this.articleProvider});

  Future<void> addChannel(Channel channel) async {
    await channelProvider.insert(channel.toMap());
  }

  Future<void> addChannels(List<Channel> chs) async {
    List<Map<String, dynamic>> data = chs.map((e) => e.toMap()).toList();
    AppLogger.instance.d('channel provider:$channelProvider');
    await channelProvider.batchInsert(data);
  }

  Future<List<Channel>> fetchChannels() async {
    List<Map<String, dynamic>>? data = await channelProvider.query();
    AppLogger.instance.d('fetch channels result $data');
    return data?.map((e) => Channel.fromMap(e)).toList() ?? [];
  }

  Future<void> removeChannel(String link) async {
    await channelProvider.deleteByLink(link);
  }

  Future<void> refreshChannel(Channel channel) async {
    List<Article> parsedArticles = await FeedParser.parseArticles(channel.link);
    List<Map<String, dynamic>> data =
        parsedArticles.map((e) => e.toMap()).toList();
    await articleProvider.batchInsert(data);
    await channelProvider.checkReadStatus(channel.link);
  }

  Future<void> refreshChannels(List<Channel> channels) async {
    for (var channel in channels) {
      await refreshChannel(channel);
    }
  }

  Future<void> minusOneUnread(String channel) async {
    await channelProvider.minusOneUnread(channel);
  }
}
