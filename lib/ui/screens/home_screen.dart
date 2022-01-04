import 'package:fluent_rss/theme/app_theme.dart';
import 'package:fluent_rss/ui/screens/history_screen.dart';
import 'package:fluent_rss/ui/screens/reading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'article_screen.dart';
import 'category_screen.dart';
import 'channel_screen.dart';
import 'favorite_screen.dart';
import 'feed_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: GlobalTheme.light,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return CategoryScreen();
                case '/articles':
                  return ArticleScreen();
                case '/reading':
                  return ReadingScreen();
                case '/feed':
                  return FeedScreen();
                case '/history':
                  return HistoryScreen();
                case '/favorites':
                  return HistoryScreen();
                default:
                  return Text("invalid route");
              }
            });
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: IndexedStack(
            children: [
              CategoryScreen(),
              FeedScreen(),
              FavoriteScreen(),
              HistoryScreen()
            ],
            index: selectedIndex,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.feed), label: "channel"),
              BottomNavigationBarItem(icon: Icon(Icons.today), label: "feeds"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark), label: "favorites"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: "history"),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            currentIndex: selectedIndex,
          )),
    );
  }
}
