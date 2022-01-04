import 'package:fluent_rss/ui/screens/history_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'category_screen.dart';
import 'favorite_screen.dart';
import 'feed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          items: const [
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
        ));
  }
}
