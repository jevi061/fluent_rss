import 'dart:async';
import 'dart:math';

import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/event/app_event.dart';
import 'package:fluent_rss/business/event/article_event.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/business/event/today_event.dart';
import 'package:fluent_rss/business/state/app_state.dart';
import 'package:fluent_rss/business/state/today_state.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class TodayBloc extends Bloc<TodayEvent, TodayState> {
  ArticleRepository articleRepository;
  TodayBloc({required this.articleRepository})
      : super(TodayState.ready(articles: [])) {
    on<TodayUpdated>(_onTodayUpdated);
    on<TodayStarted>(_onTodayStarted);
  }
  Future<void> _onTodayUpdated(
      TodayUpdated event, Emitter<TodayState> emitter) async {
    emitter(TodayState.ready(articles: event.articles));
  }

  Future<void> _onTodayStarted(
      TodayStarted event, Emitter<TodayState> emitter) async {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    Logger().d("now is :${date.toString()}");
    List<Article> articles =
        await articleRepository.queryTimeAfter(date.millisecondsSinceEpoch);
    emitter(TodayState.ready(articles: articles));
  }
}
