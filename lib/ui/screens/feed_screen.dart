import 'package:fluent_rss/ui/pages/all_article_page.dart';
import 'package:fluent_rss/ui/pages/today_article_page.dart';
import 'package:fluent_rss/ui/pages/unread_article_page.dart';
import 'package:fluent_rss/ui/widgets/article_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Smart Feeds"),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "all",
                ),
                Tab(text: "unread"),
                Tab(
                  text: "today",
                )
              ],
            ),
          ),
          body: TabBarView(children: [
            AllArticlePage(),
            UnreadArticlePage(),
            TodayArticlePage(),
          ]),
        ));
  }
}
