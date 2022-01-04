import 'package:fluent_rss/ui/pages/all_article_page.dart';
import 'package:fluent_rss/ui/pages/today_article_page.dart';
import 'package:fluent_rss/ui/pages/unread_article_page.dart';
import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Smart Feeds"),
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
