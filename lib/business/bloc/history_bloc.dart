import 'dart:async';
import 'dart:math';

import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/event/app_event.dart';
import 'package:fluent_rss/business/event/article_event.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/business/event/history_event.dart';
import 'package:fluent_rss/business/event/today_event.dart';
import 'package:fluent_rss/business/state/app_state.dart';
import 'package:fluent_rss/business/state/history_state.dart';
import 'package:fluent_rss/business/state/today_state.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:fluent_rss/data/repository/history_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  ArticleRepository articleRepository;
  HistoryBloc({required this.articleRepository})
      : super(HistoryState.ready(articles: [])) {
    on<HistoryUpdated>(_onHistoryUpdated);
    on<HistoryStarted>(_onHistoryStarted);
  }
  Future<void> _onHistoryUpdated(
      HistoryUpdated event, Emitter<HistoryState> emitter) async {
    await articleRepository.updateReadStatus(event.article.uuid, 1);
    var list = await articleRepository.queryByRead(1);
    emitter(HistoryState.ready(articles: list));
  }

  Future<void> _onHistoryStarted(
      HistoryStarted event, Emitter<HistoryState> emitter) async {
    var list = await articleRepository.queryByRead(1);
    emitter(HistoryState.ready(articles: list));
  }
}
