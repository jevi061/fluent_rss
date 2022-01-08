import 'package:fluent_rss/business/blocs/channel/add_channel_bloc.dart';
import 'package:fluent_rss/business/blocs/app/app_bloc.dart';
import 'package:fluent_rss/business/blocs/article/article_bloc.dart';
import 'package:fluent_rss/business/blocs/category/category_bloc.dart';
import 'package:fluent_rss/business/blocs/channel/channel_bloc.dart';
import 'package:fluent_rss/business/blocs/feed/all_feed_bloc.dart';
import 'package:fluent_rss/business/blocs/app/app_event.dart';
import 'package:fluent_rss/business/blocs/category/category_event.dart';
import 'package:fluent_rss/business/blocs/channel/channel_event.dart';
import 'package:fluent_rss/business/blocs/feed/all_feed_event.dart';
import 'package:fluent_rss/data/providers/article_status_provider.dart';
import 'package:fluent_rss/data/providers/category_provider.dart';
import 'package:fluent_rss/data/providers/channel_provider.dart';
import 'package:fluent_rss/data/repository/category_repository.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:fluent_rss/router/app_router.dart';
import 'package:fluent_rss/theme/app_theme.dart';
import 'package:fluent_rss/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business/blocs/favorite/favorite_bloc.dart';
import 'business/blocs/feed/today_feed_bloc.dart';
import 'business/blocs/feed/today_feed_event.dart';
import 'business/blocs/feed/unread_feed_bloc.dart';
import 'business/blocs/feed/unread_feed_event.dart';
import 'business/blocs/history/history_bloc.dart';
import 'business/blocs/read/reading_bloc.dart';
import 'business/blocs/favorite/favorite_event.dart';
import 'business/blocs/history/history_event.dart';
import 'data/providers/article_provider.dart';
import 'data/providers/channel_status_provider.dart';
import 'data/repository/article_repository.dart';

void main() {
  var categoryProvider = CategoryProvider();
  var channelProvider = ChannelProvider();
  var channelStatusProvider = ChannelStatusProvider();
  var articleProvider = ArticleProvider();
  var articleStatusProvider = ArticleStatusProvider();
  var articleRepository = ArticleRepository(
      articleStatusProvider: articleStatusProvider,
      channelProvider: channelProvider,
      articleProvider: articleProvider);
  var channelRepository = ChannelRepository(
      channelProvider: channelProvider,
      channelStatusProvider: channelStatusProvider,
      articleProvider: articleProvider,
      articleStatusProvider: articleStatusProvider);
  var categoryRepository = CategoryRepository(
      categoryProvider: categoryProvider, channelProvider: channelProvider);
  var app = MultiBlocProvider(
    providers: [
      BlocProvider<ChannelBloc>(
          lazy: false,
          create: (BuildContext context) => ChannelBloc(
              categoryRepository: categoryRepository,
              channelRepository: channelRepository,
              articleRepository: articleRepository)
            ..add(ChannelStarted())),
      BlocProvider<ArticleBloc>(
          lazy: false,
          create: (BuildContext context) => ArticleBloc(
              channelRepository: channelRepository,
              articleRepository: articleRepository)),
      BlocProvider<HistoryBloc>(
          lazy: false,
          create: (BuildContext context) =>
              HistoryBloc(articleRepository: articleRepository)
                ..add(HistoryStarted())),
      BlocProvider<FavoriteBloc>(
          lazy: false,
          create: (BuildContext context) =>
              FavoriteBloc(articleRepository: articleRepository)
                ..add(FavoriteStarted())),
      BlocProvider<ReadingBloc>(
          lazy: false, create: (BuildContext context) => ReadingBloc()),
      BlocProvider<AppBloc>(
          lazy: false,
          create: (BuildContext context) => AppBloc()..add(AppStarted())),
      BlocProvider(create: (BuildContext context) => AddChannelBloc()),
      BlocProvider(
          create: (BuildContext context) =>
              AllFeedBloc(articleRepository: articleRepository)
                ..add(AllFeedStarted())),
      BlocProvider(
          create: (BuildContext context) =>
              UnreadFeedBloc(articleRepository: articleRepository)
                ..add(UnreadFeedStarted())),
      BlocProvider(
          create: (BuildContext context) =>
              TodayFeedBloc(articleRepository: articleRepository)
                ..add(TodayFeedStarted())),
      BlocProvider(
          create: (BuildContext context) =>
              CategoryBloc(categoryRepository: categoryRepository)
                ..add(CategoryStarted()))
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.controller,
      initialRoute: AppRouter.homeScreen,
    ),
  );
  runApp(app);
}
