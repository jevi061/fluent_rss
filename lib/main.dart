import 'package:fluent_rss/business/bloc/add_channel_bloc.dart';
import 'package:fluent_rss/business/bloc/app_bloc.dart';
import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/bloc/feed_bloc.dart';
import 'package:fluent_rss/business/event/app_event.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/business/event/feed_event.dart';
import 'package:fluent_rss/data/providers/article_status_provider.dart';
import 'package:fluent_rss/data/providers/category_provider.dart';
import 'package:fluent_rss/data/providers/channel_provider.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:fluent_rss/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business/bloc/favorite_bloc.dart';
import 'business/bloc/history_bloc.dart';
import 'business/bloc/reading_bloc.dart';
import 'business/event/favorite_event.dart';
import 'business/event/history_event.dart';
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
      cagetoryProvider: categoryProvider,
      channelProvider: channelProvider,
      channelStatusProvider: channelStatusProvider,
      articleProvider: articleProvider);
  var app = MultiBlocProvider(
    providers: [
      BlocProvider<ChannelBloc>(
          lazy: false,
          create: (BuildContext context) => ChannelBloc(
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
              FeedBloc(articleRepository: articleRepository)
                ..add(AllFeedsStarted())),
    ],
    child: HomeScreen(),
  );
  runApp(app);
}
