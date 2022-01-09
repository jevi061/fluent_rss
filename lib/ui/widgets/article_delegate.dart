import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:fluent_rss/ui/widgets/article_tile.dart';
import 'package:flutter/material.dart';

class ArticleSearchDelegate extends SearchDelegate {
  ArticleRepository repository;
  ArticleSearchDelegate(this.repository);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          showResults(context);
        },
        icon: const Icon(Icons.search),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Article>>(
        future: repository.searchArticles(query),
        builder: (context, snap) {
          if (snap.hasData) {
            return Scrollbar(
                child: ListView.builder(
                    itemCount: snap.data?.length,
                    itemBuilder: (context, index) {
                      return ArticleTile(article: snap.data![index]);
                    }));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: repository.searchArticleTitles(query),
        builder: (context, snap) {
          if (snap.hasData) {
            return Scrollbar(
                child: ListView.builder(
                    itemCount: snap.data?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snap.data?[index] ?? ""),
                        onTap: () {
                          query = snap.data?[index] ?? "";
                          showResults(context);
                        },
                      );
                    }));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
