import 'package:fluent_rss/ui/screens/article_screen.dart';
import 'package:fluent_rss/ui/screens/channel_screen.dart';
import 'package:fluent_rss/ui/screens/favorite_screen.dart';
import 'package:fluent_rss/ui/screens/feed_screen.dart';
import 'package:fluent_rss/ui/screens/history_screen.dart';
import 'package:fluent_rss/ui/screens/home_screen.dart';
import 'package:fluent_rss/ui/screens/reading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String homeScreen = "/";
  static const String channelScreen = "/channels";
  static const String articleScreen = "/articles";
  static const String readScreen = "/read";
  static const String feedScreen = "/feeds";
  static const String historyScreen = "/history";
  static const String favoriteScreen = "/favorites";
  static Route<dynamic> controller(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(
            settings: settings, builder: (context) => HomeScreen());
      case channelScreen:
        return MaterialPageRoute(
            settings: settings, builder: (context) => ChannelScreen());
      case articleScreen:
        return MaterialPageRoute(
            settings: settings, builder: (context) => ArticleScreen());
      case readScreen:
        return MaterialPageRoute(
            settings: settings, builder: (context) => ReadingScreen());
      case feedScreen:
        return MaterialPageRoute(
            settings: settings, builder: (context) => FeedScreen());
      case historyScreen:
        return MaterialPageRoute(
            settings: settings, builder: (context) => HistoryScreen());
      case favoriteScreen:
        return MaterialPageRoute(
            settings: settings, builder: (context) => FavoriteScreen());
      default:
        return MaterialPageRoute(
            builder: (context) => Text("something went wrong"));
    }
  }
}
