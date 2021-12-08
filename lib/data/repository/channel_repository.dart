import 'package:fluent_rss/business/log/logger.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/providers/article_provider.dart';
import 'package:fluent_rss/data/providers/channel_provider.dart';
import 'package:fluent_rss/services/feed_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class ChannelRepository {
  ChannelProvider channelProvider;
  ArticleProvider articleProvider;
  ChannelRepository(
      {required this.channelProvider, required this.articleProvider});

  void addChannel(Channel channel) async {
    channelProvider.insert(channel.toMap());
  }

  Future<void> addChannels(List<Channel> chs) async {
    List<Map<String, dynamic>> data = chs.map((e) => e.toMap()).toList();
    Logger().d('channel provider:$channelProvider');
    channelProvider.batchInsert(data);
  }

  Future<List<Channel>> fetchChannels() async {
    List<Map<String, dynamic>>? data = await channelProvider.query();
    Logger().d('fetch channels result $data');
    return data?.map((e) => Channel.fromMap(e)).toList() ?? [];
  }

  Future<void> syncChannelArticles(List<Channel> channels) async {
    var parser = FeedParser();
    for (var channel in channels) {
      List<Article> parsedArticles = [];
      if (channel.type == "rss") {
        parsedArticles = await parser.parseRSS(channel.link);
      } else if (channel.type == "atom") {
        parsedArticles = await parser.parseAtom(channel.link);
      }
      List<Map<String, dynamic>> data =
          parsedArticles.map((e) => e.toMap()).toList();
      await articleProvider.batchInsert(data);
    }
  }

  Future<void> syncArticles() async {
    List<Channel> channels = await fetchChannels();

    var utc = DateTime.now().millisecondsSinceEpoch;
    channels = channels
        .where((element) => utc - element.lastCheck > 24 * 3600)
        .toList();
    var parser = FeedParser();
    List<Article> parsedArticles = [];
    for (Channel channel in channels) {
      if (channel.type == "rss") {
        parsedArticles = await parser.parseRSS(channel.link);
      } else if (channel.type == "atom") {
        parsedArticles = await parser.parseAtom(channel.link);
      }
      List<Map<String, dynamic>> data =
          parsedArticles.map((e) => e.toMap()).toList();
      articleProvider.batchInsert(data);
    }
  }
}
