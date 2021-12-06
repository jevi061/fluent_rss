import 'package:fluent_rss/business/bloc/app_bloc.dart';
import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/event/app_event.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/business/event/today_event.dart';
import 'package:fluent_rss/data/providers/channel_provider.dart';
import 'package:fluent_rss/data/providers/history_provider.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:fluent_rss/ui/screens/article_screen.dart';
import 'package:fluent_rss/ui/screens/channel_screen.dart';
import 'package:fluent_rss/ui/screens/history_screen.dart';
import 'package:fluent_rss/ui/screens/home_screen.dart';
import 'package:fluent_rss/ui/screens/reading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business/bloc/favorite_bloc.dart';
import 'business/bloc/history_bloc.dart';
import 'business/bloc/reading_bloc.dart';
import 'business/bloc/today_bloc.dart';
import 'business/event/favorite_event.dart';
import 'business/event/history_event.dart';
import 'data/providers/article_provider.dart';
import 'data/providers/favorite_provider.dart';
import 'data/repository/article_repository.dart';
import 'data/repository/favorite_repository.dart';
import 'data/repository/history_repository.dart';

void main() {
  var channelProvider = ChannelProvider();
  var articleProvider = ArticleProvider();
  var historyProvider = HistoryProvider();
  var favoriteProvider = FavoriteProvider();
  var app = MultiBlocProvider(
    providers: [
      BlocProvider<ChannelBloc>(
          lazy: false,
          create: (BuildContext context) => ChannelBloc(
              channelRepository:
                  ChannelRepository(channelProvider: channelProvider))
            ..add(ChannelStarted())),
      BlocProvider<ArticleBloc>(
          lazy: false,
          create: (BuildContext context) => ArticleBloc(
              articleRepository: ArticleRepository(
                  channelProvider: channelProvider,
                  articleProvider: articleProvider))),
      BlocProvider<TodayBloc>(
          lazy: false,
          create: (BuildContext context) => TodayBloc(
              articleRepository: ArticleRepository(
                  channelProvider: channelProvider,
                  articleProvider: articleProvider))
            ..add(TodayStarted())),
      BlocProvider<HistoryBloc>(
          lazy: false,
          create: (BuildContext context) => HistoryBloc(
                  historyRepository: HistoryRepository(
                historyProvider: historyProvider,
              ))
                ..add(HistoryStarted())),
      BlocProvider<FavoriteBloc>(
          lazy: false,
          create: (BuildContext context) => FavoriteBloc(
                  favoriteRepository: FavoriteRepository(
                favoriteProvider: favoriteProvider,
              ))
                ..add(FavoriteStarted())),
      BlocProvider<ReadingBloc>(
          lazy: false, create: (BuildContext context) => ReadingBloc()),
      BlocProvider<AppBloc>(
          lazy: false,
          create: (BuildContext context) => AppBloc()..add(AppStarted())),
    ],
    child: HomeScreen(),
  );
  runApp(app);
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluent RSS',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      routes: {
        "/channels": (context) => ChannelScreen(),
        "/articles": (context) => ArticleScreen(),
        "/reading": (context) => ReadingScreen(),
        "/home": (context) => HomeScreen(),
        "/history": (context) => HistoryScreen(),
      },
      initialRoute: "/home",
      debugShowCheckedModeBanner: false,
    );
  }
}
