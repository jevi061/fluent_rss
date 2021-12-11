import 'package:fluent_rss/data/domains/article.dart';
import 'package:logger/logger.dart';
import 'package:webfeed/domain/atom_feed.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:dio/dio.dart';

class FeedParser {
  Future<List<Article>> parseRSS(String link) async {
    List<Article> articles = [];
    Uri rssUri = Uri.parse(link);
    Response<dynamic> response;
    try {
      response = await Dio().get(link);
    } catch (e) {
      return articles;
    }
    RssFeed feed;
    try {
      feed = RssFeed.parse(response.data);
    } catch (e) {
      return parseAtomXml(link, response.data);
    }
    feed.items?.forEach((element) {
      var now = DateTime.now();
      var pubDate = element.pubDate ?? now;
      var article = Article(
          channel: link,
          link: element.link ?? "",
          uuid: element.guid ?? "",
          title: element.title ?? "",
          subtitle: element.description ?? "",
          published: pubDate.millisecondsSinceEpoch,
          starred: 0,
          read: 0);
      articles.add(article);
    });
    return articles;
  }

  Future<List<Article>> parseAtom(String link) async {
    List<Article> articles = [];
    Uri rssUri = Uri.parse(link);
    Response<dynamic> response;
    try {
      response = await Dio().get(link);
    } catch (e) {
      return articles;
    }
    AtomFeed feed = AtomFeed.parse(response.data);
    feed.items?.forEach((element) {
      var pubDate = element.updated ?? DateTime.now();
      var article = Article(
          channel: link,
          link: element.links?.first.href ?? "",
          uuid: element.id ?? "",
          title: element.title ?? "",
          subtitle: element.summary ?? "",
          published: pubDate.millisecondsSinceEpoch,
          starred: 0,
          read: 0);
      articles.add(article);
    });
    return articles;
  }

  Future<List<Article>> parseAtomXml(String link, String xml) async {
    AtomFeed feed = AtomFeed.parse(xml);
    List<Article> articles = [];
    feed.items?.forEach((element) {
      var pubDate = element.updated ?? DateTime.now();
      var article = Article(
          channel: link,
          link: element.links?.first.href ?? "",
          uuid: element.id ?? "",
          title: element.title ?? "",
          subtitle: element.summary ?? "",
          published: pubDate.millisecondsSinceEpoch,
          starred: 0,
          read: 0);
      articles.add(article);
    });
    return articles;
  }
}
