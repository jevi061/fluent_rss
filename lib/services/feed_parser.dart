import 'package:fluent_rss/assets/constants.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:webfeed/domain/atom_feed.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

const tenSeconds = 10000;
var dioOptions = BaseOptions(
    connectTimeout: tenSeconds,
    receiveTimeout: tenSeconds,
    sendTimeout: tenSeconds);

class FeedParser {
  static List<Article> _parseRSSFeed(RssFeed feed, String link) {
    List<Article> articles = [];
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
      );
      articles.add(article);
    });
    return articles;
  }

  Future<List<Article>> parseAtom(String link) async {
    List<Article> articles = [];
    Response<dynamic> response;
    try {
      response = await Dio(dioOptions).get(link);
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
      );
      articles.add(article);
    });
    return articles;
  }

  static Future<Channel?> parseChannel(String link) async {
    Response<dynamic> response;
    try {
      response = await Dio(dioOptions).get(link);
    } catch (e) {
      AppLogger.instance.d('load channel failed with http get:${e.toString()}');
      return null;
    }
    Uri uri = Uri.parse(link);
    var iconUrl = path.join(uri.origin, FeedConstants.iconName);
    try {
      var feed = RssFeed.parse(response.data);
      return Channel(
          title: feed.title ?? '',
          link: link,
          description: feed.description ?? '',
          type: FeedConstants.RSS,
          version: '0',
          iconUrl: iconUrl,
          categoryId: 1);
    } catch (e) {
      AppLogger.instance.d('parse channel rss way:${e.toString()}');
    }
    try {
      var feed = AtomFeed.parse(response.data);
      return Channel(
          title: feed.title ?? '',
          link: link,
          description: feed.subtitle ?? '',
          type: FeedConstants.Atom,
          version: '0',
          iconUrl: iconUrl,
          categoryId: 1);
    } catch (e) {
      AppLogger.instance.d('parse channel atom way:${e.toString()}');
    }
  }

  static List<Article> _parseAtomFeed(AtomFeed feed, String link) {
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
      );
      articles.add(article);
    });
    return articles;
  }

  static Future<List<Article>> parseArticles(String link) async {
    List<Article> articles = [];
    Response<dynamic> response;
    try {
      response = await Dio(dioOptions).get(link);
    } catch (e) {
      AppLogger.instance
          .d('load channel with http get failed:${e.toString()} ');
      return articles;
    }
    //try rss
    RssFeed feed;
    try {
      feed = RssFeed.parse(response.data);
      return _parseRSSFeed(feed, link);
    } catch (e) {
      AppLogger.instance
          .d('parse channel articles rss way failed:${e.toString()} ');
    }
    AtomFeed atomFeed;
    try {
      atomFeed = AtomFeed.parse(response.data);
      return _parseAtomFeed(atomFeed, link);
    } catch (e) {
      AppLogger.instance
          .d('parse channel articles atom way failed:${e.toString()} ');
    }
    return articles;
  }
}
