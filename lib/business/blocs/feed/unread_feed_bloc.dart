import 'dart:async';

import 'package:fluent_rss/business/blocs/feed/unread_feed_event.dart';
import 'package:fluent_rss/business/blocs/feed/unread_feed_state.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnreadFeedBloc extends Bloc<UnreadFeedEvent, UnreadFeedState> {
  static const int limit = 20;
  ArticleRepository articleRepository;
  UnreadFeedBloc({required this.articleRepository})
      : super(UnreadFeedState([])) {
    on<UnreadFeedStarted>(_onUnreadFeedStarted);
    on<UnreadFeedLoadTriggered>(_onUnreadFeedLoadTriggered);
    on<UnreadFeedOutdated>(_onUnreadFeedOutdated);
  }

  Future<void> _onUnreadFeedStarted(
      UnreadFeedStarted event, Emitter<UnreadFeedState> emitter) async {
    var unread = await articleRepository.queryPageByRead(0, 0, limit);
    emitter(UnreadFeedState(unread));
  }

  Future<void> _onUnreadFeedLoadTriggered(
      UnreadFeedLoadTriggered event, Emitter<UnreadFeedState> emitter) async {
    var all = await articleRepository.queryPageByRead(
        0, state.articles.length, limit);
    emitter(UnreadFeedState(List.of(state.articles)..addAll(all)));
  }

  Future<void> _onUnreadFeedOutdated(
      UnreadFeedOutdated event, Emitter<UnreadFeedState> emitter) async {
    var unread =
        await articleRepository.queryPageByRead(0, 0, state.articles.length);
    emitter(UnreadFeedState(unread));
  }
}
