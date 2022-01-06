import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/article_status.dart';
import 'package:fluent_rss/data/providers/article_provider.dart';
import 'package:fluent_rss/data/providers/article_status_provider.dart';
import 'package:fluent_rss/data/providers/channel_provider.dart';

class ArticleRepository {
  ChannelProvider channelProvider;
  ArticleProvider articleProvider;
  ArticleStatusProvider articleStatusProvider;
  ArticleRepository(
      {required this.articleProvider,
      required this.channelProvider,
      required this.articleStatusProvider});

  Future<void> addArticle(Article article) async {
    await articleProvider.insert(article);
    await articleStatusProvider
        .insert(ArticleStatus(articleId: article.uuid, read: 0, starred: 0));
    await articleStatusProvider
        .insert(ArticleStatus(articleId: article.uuid, read: 0, starred: 0));
  }

  Future<void> addArticles(List<Article> articles) async {
    var status = articles
        .map((e) => ArticleStatus(articleId: e.uuid, read: 0, starred: 0))
        .toList();
    await articleProvider.batchInsert(articles);
    await articleStatusProvider.batchInsert(status);
  }

  Future<List<Article>> queryByLink(String link) async {
    var articles = await articleProvider.queryByChannelLink(link);
    for (var article in articles) {
      var status = await articleStatusProvider.queryByArticleId(article.uuid);
      article.status =
          status ?? ArticleStatus(read: 0, starred: 0, articleId: article.uuid);
    }
    return articles;
  }

  Future<List<Article>> queryTimeAfter(int timestamp) async {
    var articles = await articleProvider.queryTimeAfter(timestamp);
    for (var article in articles) {
      var status = await articleStatusProvider.queryByArticleId(article.uuid);
      article.status =
          status ?? ArticleStatus(read: 0, starred: 0, articleId: article.uuid);
    }
    return articles;
  }

  Future<void> updateArticleStarStatus(String articleId, int star) async {
    await articleStatusProvider.updateStarStatus(articleId, star);
  }

  Future<void> updateArticleReadStatus(String articleId, int read) async {
    await articleStatusProvider.updateReadStatus(articleId, read);
  }

  Future<List<Article>> queryByRead(int read) async {
    var articles = await queryAll();
    var readArticles =
        articles.where((element) => element.status?.read == read).toList();
    // associate article status
    for (var article in readArticles) {
      var status = await articleStatusProvider.queryByArticleId(article.link);
      article.status =
          status ?? ArticleStatus(read: 0, starred: 0, articleId: article.uuid);
    }
    return readArticles;
  }

  Future<List<Article>> queryByStar(int starred) async {
    var articles = await queryAll();
    var starredArticles = articles
        .where((element) => element.status?.starred == starred)
        .toList();
    // associate article status
    for (var article in starredArticles) {
      var status = await articleStatusProvider.queryByArticleId(article.link);
      article.status =
          status ?? ArticleStatus(read: 0, starred: 0, articleId: article.uuid);
    }
    return starredArticles;
  }

  Future<List<Article>> queryAll() async {
    var articles = await articleProvider.queryAll();
    // associate article status
    for (var article in articles) {
      var status = await articleStatusProvider.queryByArticleId(article.link);
      article.status =
          status ?? ArticleStatus(read: 0, starred: 0, articleId: article.uuid);
    }
    return articles;
  }
}
