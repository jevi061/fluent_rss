import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:fluent_rss/ui/pages/all_article_page.dart';
import 'package:fluent_rss/ui/pages/today_article_page.dart';
import 'package:fluent_rss/ui/pages/unread_article_page.dart';
import 'package:fluent_rss/ui/widgets/article_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            title: Container(
              margin: const EdgeInsets.only(top: 16),
              child: TextField(
                autofocus: false,
                decoration: const InputDecoration(
                  hintText: "Search articles",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  var articleRepository =
                      RepositoryProvider.of<ArticleRepository>(context);
                  showSearch(
                      context: context,
                      delegate: ArticleSearchDelegate(articleRepository));
                },
              ),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "today",
                ),
                Tab(text: "unread"),
                Tab(
                  text: "all",
                ),
              ],
            ),
          ),
          body: const TabBarView(children: [
            TodayArticlePage(),
            UnreadArticlePage(),
            AllArticlePage(),
          ]),
        ));
  }
}
