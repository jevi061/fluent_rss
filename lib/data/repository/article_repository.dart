import 'package:fluent_rss/business/log/logger.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/providers/article_provider.dart';
import 'package:fluent_rss/data/providers/channel_provider.dart';
import 'package:fluent_rss/services/feed_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class ArticleRepository {
  ArticleProvider articleProvider;
  ChannelProvider channelProvider;
  ArticleRepository(
      {required this.channelProvider, required this.articleProvider});

  Future<void> addArticle(Article article) async {
    articleProvider.insert(article.toMap());
  }

  Future<void> addArticles(List<Article> articles) async {
    List<Map<String, dynamic>> data = articles.map((e) => e.toMap()).toList();
    articleProvider.batchInsert(data);
  }

  Future<void> syncArticles() async {
    List<Map<String, dynamic>>? data = await channelProvider.query();
    List<Channel> channels =
        data?.map((e) => Channel.fromMap(e)).toList() ?? [];
    var utc = DateTime.now().millisecondsSinceEpoch;
    channels = channels
        .where((element) => utc - element.lastCheck > 24 * 3600)
        .toList();
    var parser = FeedParser();
    for (Channel channel in channels) {
      if (channel.type == "rss") {
        List<Article> parsedArticles = await parser.parseRSS(channel.link);
        await addArticles(parsedArticles);
      } else if (channel.type == "atom") {
        List<Article> parsedArticles = await parser.parseAtom(channel.link);
        await addArticles(parsedArticles);
      }
    }
  }

  Future<List<Article>> syncArticlesByChannel(Channel channel) async {
    var parser = FeedParser();
    List<Article> parsedArticles = [];
    if (channel.type == "rss") {
      parsedArticles = await parser.parseRSS(channel.link);
      await addArticles(parsedArticles);
    } else if (channel.type == "atom") {
      parsedArticles = await parser.parseAtom(channel.link);
      await addArticles(parsedArticles);
    }
    Logger().d("parsed articles:${parsedArticles.length}");
    await channelProvider.updateSyncTime(
        channel.link, DateTime.now().millisecondsSinceEpoch);
    return parsedArticles;
  }

  Future<List<Article>> queryByLink(String link) async {
    List<Map<String, dynamic>>? data =
        await articleProvider.queryByChannelLink(link);
    List<Article> articles =
        data?.map((e) => Article.fromMap(e)).toList() ?? [];
    return articles;
  }

  Future<List<Article>> queryTimeAfter(int timestamp) async {
    List<Map<String, dynamic>>? data =
        await articleProvider.queryTimeAfter(timestamp);
    List<Article> articles =
        data?.map((e) => Article.fromMap(e)).toList() ?? [];
    return articles;
  }

  Future<List<Article>> queryAll() async {
    List<Map<String, dynamic>>? data = await articleProvider.queryAll();
    List<Article> articles =
        data?.map((e) => Article.fromMap(e)).toList() ?? [];
    return articles;
  }
}
