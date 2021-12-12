import 'dart:async';

import 'package:fluent_rss/business/event/favorite_event.dart';
import 'package:fluent_rss/business/state/favorite_state.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  ArticleRepository articleRepository;
  FavoriteBloc({required this.articleRepository})
      : super(FavoriteState.ready(articles: [])) {
    on<FavoriteUpdated>(_onFavoriteUpdated);
    on<FavoriteStarted>(_onFavoriteStarted);
  }
  Future<void> _onFavoriteUpdated(
      FavoriteUpdated event, Emitter<FavoriteState> emitter) async {
    await articleRepository.updateStarStatus(
        event.article.uuid, event.article.starred);
    var list = await articleRepository.queryByStar(1);
    emitter(FavoriteState.ready(articles: list));
  }

  Future<void> _onFavoriteStarted(
      FavoriteStarted event, Emitter<FavoriteState> emitter) async {
    var list = await articleRepository.queryByStar(1);
    emitter(FavoriteState.ready(articles: list));
  }
}
