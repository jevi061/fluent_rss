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
  var repositoryProviders = makeRepositoryProviders();
  var blocProviders = makeBlocProviders();
  var app = makeApp(repositoryProviders, blocProviders);
  runApp(app);
}

List<RepositoryProvider> makeRepositoryProviders() {
  var categoryProvider = CategoryProvider();
  var channelProvider = ChannelProvider();
  var channelStatusProvider = ChannelStatusProvider();
  var articleProvider = ArticleProvider();
  var articleStatusProvider = ArticleStatusProvider();
  return [
    RepositoryProvider<ArticleRepository>(
      create: (context) => ArticleRepository(
          articleProvider: articleProvider,
          channelProvider: channelProvider,
          articleStatusProvider: articleStatusProvider),
    ),
    RepositoryProvider<ChannelRepository>(
      create: (context) => ChannelRepository(
          channelProvider: channelProvider,
          articleProvider: articleProvider,
          channelStatusProvider: channelStatusProvider,
          articleStatusProvider: articleStatusProvider),
    ),
    RepositoryProvider<CategoryRepository>(
      create: (context) => CategoryRepository(
          categoryProvider: categoryProvider, channelProvider: channelProvider),
    ),
  ];
}

List<BlocProvider> makeBlocProviders() {
  return [
    BlocProvider<ChannelBloc>(
        lazy: false,
        create: (BuildContext context) => ChannelBloc(
            categoryRepository:
                RepositoryProvider.of<CategoryRepository>(context),
            channelRepository:
                RepositoryProvider.of<ChannelRepository>(context),
            articleRepository:
                RepositoryProvider.of<ArticleRepository>(context))
          ..add(ChannelStarted())),
    BlocProvider<ArticleBloc>(
        lazy: false,
        create: (BuildContext context) => ArticleBloc(
            channelRepository:
                RepositoryProvider.of<ChannelRepository>(context),
            articleRepository:
                RepositoryProvider.of<ArticleRepository>(context))),
    BlocProvider<HistoryBloc>(
        lazy: false,
        create: (BuildContext context) => HistoryBloc(
            articleRepository:
                RepositoryProvider.of<ArticleRepository>(context))
          ..add(HistoryStarted())),
    BlocProvider<FavoriteBloc>(
        lazy: false,
        create: (BuildContext context) => FavoriteBloc(
            articleRepository:
                RepositoryProvider.of<ArticleRepository>(context))
          ..add(FavoriteStarted())),
    BlocProvider<ReadingBloc>(
        lazy: false,
        create: (BuildContext context) => ReadingBloc(
            articleRepository:
                RepositoryProvider.of<ArticleRepository>(context))),
    BlocProvider<AppBloc>(
        lazy: false,
        create: (BuildContext context) => AppBloc()..add(AppStarted())),
    BlocProvider<AddChannelBloc>(
        create: (BuildContext context) => AddChannelBloc()),
    BlocProvider<AllFeedBloc>(
        create: (BuildContext context) => AllFeedBloc(
            articleRepository:
                RepositoryProvider.of<ArticleRepository>(context))
          ..add(AllFeedStarted())),
    BlocProvider<UnreadFeedBloc>(
        create: (BuildContext context) => UnreadFeedBloc(
            articleRepository:
                RepositoryProvider.of<ArticleRepository>(context))
          ..add(UnreadFeedStarted())),
    BlocProvider<TodayFeedBloc>(
        create: (BuildContext context) => TodayFeedBloc(
            articleRepository:
                RepositoryProvider.of<ArticleRepository>(context))
          ..add(TodayFeedStarted())),
    BlocProvider<CategoryBloc>(
        create: (BuildContext context) => CategoryBloc(
            categoryRepository:
                RepositoryProvider.of<CategoryRepository>(context))
          ..add(CategoryStarted()))
  ];
}

Widget makeApp(List<RepositoryProvider> repositoryProviders,
    List<BlocProvider> blocProviders) {
  return MultiRepositoryProvider(
      providers: repositoryProviders,
      child: MultiBlocProvider(
        providers: blocProviders,
        child: MaterialApp(
          theme: AppTheme.light,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.controller,
          initialRoute: AppRouter.homeScreen,
        ),
      ));
}
