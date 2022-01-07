import 'dart:async';

import 'package:fluent_rss/business/blocs/history/history_event.dart';
import 'package:fluent_rss/business/blocs/history/history_state.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  ArticleRepository articleRepository;
  HistoryBloc({required this.articleRepository})
      : super(HistoryState.ready(articles: [])) {
    on<HistoryUpdated>(_onHistoryUpdated);
    on<HistoryStarted>(_onHistoryStarted);
  }
  Future<void> _onHistoryUpdated(
      HistoryUpdated event, Emitter<HistoryState> emitter) async {
    var list = await articleRepository.queryByRead(1);
    emitter(HistoryState.ready(articles: list));
  }

  Future<void> _onHistoryStarted(
      HistoryStarted event, Emitter<HistoryState> emitter) async {
    var list = await articleRepository.queryByRead(1);
    emitter(HistoryState.ready(articles: list));
  }
}
