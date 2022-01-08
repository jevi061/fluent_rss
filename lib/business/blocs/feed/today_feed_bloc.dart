import 'dart:async';

import 'package:fluent_rss/business/blocs/feed/today_feed_event.dart';
import 'package:fluent_rss/business/blocs/feed/today_feed_state.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodayFeedBloc extends Bloc<TodayFeedEvent, TodayFeedState> {
  static const int limit = 20;
  ArticleRepository articleRepository;
  TodayFeedBloc({required this.articleRepository}) : super(TodayFeedState([])) {
    on<TodayFeedStarted>(_onTodayFeedStarted);
    on<TodayFeedLoadTriggered>(_onTodayFeedLoadTriggered);
  }
  Future<void> _onTodayFeedStarted(
      TodayFeedStarted event, Emitter<TodayFeedState> emitter) async {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    var today = await articleRepository.queryPageTimeAfter(
        date.millisecondsSinceEpoch, 0, limit);
    emitter(TodayFeedState(today));
  }

  Future<void> _onTodayFeedLoadTriggered(
      TodayFeedLoadTriggered event, Emitter<TodayFeedState> emitter) async {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    var today = await articleRepository.queryPageTimeAfter(
        date.millisecondsSinceEpoch, state.articles.length, limit);
    emitter(TodayFeedState(List.of(state.articles)..addAll(today)));
  }
}
