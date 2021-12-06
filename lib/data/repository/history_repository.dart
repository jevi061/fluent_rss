import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/providers/history_provider.dart';

class HistoryRepository {
  HistoryProvider historyProvider;
  HistoryRepository({required this.historyProvider});

  Future<void> addHistory(Article history) async {
    historyProvider.insert(history.toMap());
  }

  Future<List<Article>> queryByLink(String link) async {
    List<Map<String, dynamic>>? data =
        await historyProvider.queryByChannelLink(link);
    List<Article> articles =
        data?.map((e) => Article.fromMap(e)).toList() ?? [];
    return articles;
  }

  Future<List<Article>> queryTimeAfter(int timestamp) async {
    List<Map<String, dynamic>>? data =
        await historyProvider.queryTimeAfter(timestamp);
    List<Article> articles =
        data?.map((e) => Article.fromMap(e)).toList() ?? [];
    return articles;
  }

  Future<List<Article>> queryAll() async {
    List<Map<String, dynamic>>? data = await historyProvider.queryAll();
    List<Article> articles =
        data?.map((e) => Article.fromMap(e)).toList() ?? [];
    return articles;
  }
}
