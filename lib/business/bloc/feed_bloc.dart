import 'dart:async';

import 'package:fluent_rss/business/event/favorite_event.dart';
import 'package:fluent_rss/business/event/feed_event.dart';
import 'package:fluent_rss/business/state/favorite_state.dart';
import 'package:fluent_rss/business/state/feed_state.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  ArticleRepository articleRepository;
  FeedBloc({required this.articleRepository}) : super(FeedState.initial()) {
    on<AllFeedsStarted>(_onAllFeedsStarted);
    on<FeedsStateChanged>(_onFeedsStateChanged);
  }
  Future<void> _onAllFeedsStarted(
      AllFeedsStarted event, Emitter<FeedState> emitter) async {
    var all = await articleRepository.queryAll();
    var unread = await articleRepository.queryByRead(0);
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    var today =
        await articleRepository.queryTimeAfter(date.millisecondsSinceEpoch);
    emitter(FeedState(all: all, unread: unread, today: today));
  }

  Future<void> _onFeedsStateChanged(
      FeedsStateChanged event, Emitter<FeedState> emitter) async {
    var all = await articleRepository.queryAll();
    var unread = await articleRepository.queryByRead(0);
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    var today =
        await articleRepository.queryTimeAfter(date.millisecondsSinceEpoch);
    emitter(FeedState(all: all, unread: unread, today: today));
  }
}
