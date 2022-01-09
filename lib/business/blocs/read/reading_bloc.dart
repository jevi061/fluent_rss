import 'dart:async';

import 'package:fluent_rss/business/blocs/article/article_bloc.dart';
import 'package:fluent_rss/business/blocs/read/reading_event.dart';
import 'package:fluent_rss/business/blocs/read/reading_state.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadingBloc extends Bloc<ReadingEvent, ReadingState> {
  ArticleRepository articleRepository;
  ReadingBloc({required this.articleRepository}) : super(ReadingState()) {
    on<ReadingStarted>(_onReadingStarted);
    on<ReadingOutdated>(_onReadingOutdated);
  }

  Future<void> _onReadingStarted(
      ReadingStarted event, Emitter<ReadingState> emitter) async {
    emitter(ReadingState(article: event.article));
  }

  Future<void> _onReadingOutdated(
      ReadingOutdated event, Emitter<ReadingState> emitter) async {
    var article = await articleRepository.queryById(event.article.link);
    emitter(ReadingState(article: article));
  }
}
