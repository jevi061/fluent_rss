import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/providers/article_provider.dart';
import 'package:fluent_rss/data/providers/channel_provider.dart';
import 'package:fluent_rss/data/providers/channel_status_provider.dart';
import 'package:fluent_rss/services/feed_parser.dart';

class ChannelRepository {
  ChannelProvider channelProvider;
  ChannelStatusProvider channelStatusProvider;
  ArticleProvider articleProvider;
  ChannelRepository(
      {required this.channelProvider,
      required this.articleProvider,
      required this.channelStatusProvider});

  Future<void> addChannel(Channel channel) async {
    await channelProvider.insert(channel);
  }

  Future<void> addChannels(List<Channel> channels) async {
    await channelProvider.batchInsert(channels);
  }

  Future<List<Channel>> fetchChannels() async {
    // fetch channel core data
    List<Channel> channels = await channelProvider.query();
    // fetch channel status
    for (var ch in channels) {
      var channelStatus =
          await channelStatusProvider.queryChannelStatusByLink(ch.link);
      ch.status = channelStatus;
    }
    return channels;
  }

  Future<void> deleteChannelByLink(String link) async {
    await channelProvider.deleteByLink(link);
  }

  Future<void> syncChannel(Channel channel) async {
    List<Article> parsedArticles = await FeedParser.parseArticles(channel.link);
    await articleProvider.batchInsert(parsedArticles);
    await channelStatusProvider.updateReadStatus(channel.link);
  }

  Future<void> syncChannels(List<Channel> channels) async {
    for (var item in channels) {
      await syncChannel(item);
    }
  }

  // Future<void> refreshChannels(List<Channel> channels) async {
  //   for (var channel in channels) {
  //     await refreshChannel(channel);
  //   }
  // }
// here Object represents Channel|ChannelGroup
  Stream<double> refreshChannelsWithProgress(List<Object> channels) async* {
    int index = 0;
    yield 0.02;
    for (var item in channels) {
      if (item is Channel) {
        await syncChannel(item);
      } else {
        await syncChannels(item as List<Channel>);
      }
      index = index + 1;
      var percent = index / channels.length;
      yield percent;
    }
  }

  Future<void> decreaseUnread(String channel) async {
    await channelProvider.decreaseUnread(channel);
  }

  Future<List<Channel>> getChannelsByCategory(int categoryId) async {
    // fetch channel core data
    List<Channel> channels =
        await channelProvider.queryByCategoryId(categoryId);
    // fetch channel status
    for (var ch in channels) {
      var channelStatus =
          await channelStatusProvider.queryChannelStatusByLink(ch.link);
      ch.status = channelStatus;
    }
    return channels;
  }
}
