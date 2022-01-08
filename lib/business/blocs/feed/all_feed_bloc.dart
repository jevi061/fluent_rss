import 'dart:async';

import 'package:fluent_rss/business/blocs/feed/all_feed_event.dart';
import 'package:fluent_rss/business/blocs/feed/all_feed_state.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllFeedBloc extends Bloc<AllFeedEvent, AllFeedState> {
  static const int limit = 20;
  ArticleRepository articleRepository;
  AllFeedBloc({required this.articleRepository}) : super(AllFeedState([])) {
    on<AllFeedStarted>(_onAllFeedStarted);
    on<AllFeedLoadTriggered>(_onAllFeedLoadTriggered);
    on<AllFeedOutdated>(_onAllFeedOutdated);
  }
  Future<void> _onAllFeedStarted(
      AllFeedStarted event, Emitter<AllFeedState> emitter) async {
    var all = await articleRepository.queryPage(0, limit);
    emitter(AllFeedState(all));
  }

  Future<void> _onAllFeedLoadTriggered(
      AllFeedLoadTriggered event, Emitter<AllFeedState> emitter) async {
    var all = await articleRepository.queryPage(state.articles.length, limit);
    emitter(AllFeedState(List.of(state.articles)..addAll(all)));
  }

  Future<void> _onAllFeedOutdated(
      AllFeedOutdated event, Emitter<AllFeedState> emitter) async {
    var all = await articleRepository.queryPage(0, state.articles.length);
    emitter(AllFeedState(all));
  }
}
