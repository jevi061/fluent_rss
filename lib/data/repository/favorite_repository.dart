import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/providers/favorite_provider.dart';

class FavoriteRepository {
  FavoriteProvider favoriteProvider;
  FavoriteRepository({required this.favoriteProvider});

  Future<void> addFavorite(Article history) async {
    favoriteProvider.insert(history.toMap());
  }

  Future<List<Article>> queryByLink(String link) async {
    List<Map<String, dynamic>>? data =
        await favoriteProvider.queryByChannelLink(link);
    List<Article> articles =
        data?.map((e) => Article.fromMap(e)).toList() ?? [];
    return articles;
  }

  Future<List<Article>> queryTimeAfter(int timestamp) async {
    List<Map<String, dynamic>>? data =
        await favoriteProvider.queryTimeAfter(timestamp);
    List<Article> articles =
        data?.map((e) => Article.fromMap(e)).toList() ?? [];
    return articles;
  }

  Future<List<Article>> queryAll() async {
    List<Map<String, dynamic>>? data = await favoriteProvider.queryAll();
    List<Article> articles =
        data?.map((e) => Article.fromMap(e)).toList() ?? [];
    return articles;
  }
}
