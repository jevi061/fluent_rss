import 'dart:async';
import 'dart:math';

import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/event/app_event.dart';
import 'package:fluent_rss/business/event/article_event.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/business/event/favorite_event.dart';
import 'package:fluent_rss/business/event/history_event.dart';
import 'package:fluent_rss/business/event/today_event.dart';
import 'package:fluent_rss/business/state/app_state.dart';
import 'package:fluent_rss/business/state/favorite_state.dart';
import 'package:fluent_rss/business/state/history_state.dart';
import 'package:fluent_rss/business/state/today_state.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/repository/article_repository.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:fluent_rss/data/repository/favorite_repository.dart';
import 'package:fluent_rss/data/repository/history_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteRepository favoriteRepository;
  FavoriteBloc({required this.favoriteRepository})
      : super(FavoriteState.ready(articles: [])) {
    on<FavoriteUpdated>(_onFavoriteUpdated);
    on<FavoriteStarted>(_onFavoriteStarted);
  }
  Future<void> _onFavoriteUpdated(
      FavoriteUpdated event, Emitter<FavoriteState> emitter) async {
    await favoriteRepository.addFavorite(event.article);
    var list = await favoriteRepository.queryAll();
    emitter(FavoriteState.ready(articles: list));
  }

  Future<void> _onFavoriteStarted(
      FavoriteStarted event, Emitter<FavoriteState> emitter) async {
    var list = await favoriteRepository.queryAll();
    emitter(FavoriteState.ready(articles: list));
  }
}
