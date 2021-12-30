import 'package:fluent_rss/data/domains/article.dart';
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
  }

  Future<void> addArticles(List<Article> articles) async {
    await articleProvider.batchInsert(articles);
  }

  Future<List<Article>> queryByLink(String link) async {
    var articles = await articleProvider.queryByChannelLink(link);
    for (var article in articles) {
      var articleStatus =
          await articleStatusProvider.queryByArticleId(article.uuid);
      article.status = articleStatus;
    }
    return articles;
  }

  Future<List<Article>> queryTimeAfter(int timestamp) async {
    var articles = await articleProvider.queryTimeAfter(timestamp);
    for (var article in articles) {
      var articleStatus =
          await articleStatusProvider.queryByArticleId(article.uuid);
      article.status = articleStatus;
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
    return articles.where((element) => element.status?.read == read).toList();
  }

  Future<List<Article>> queryByStar(int starred) async {
    var articles = await queryAll();
    return articles
        .where((element) => element.status?.starred == starred)
        .toList();
  }

  Future<List<Article>> queryAll() async {
    return await articleProvider.queryAll();
  }
}
