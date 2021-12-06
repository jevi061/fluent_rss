import 'dart:async';
import 'dart:math';

import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/event/app_event.dart';
import 'package:fluent_rss/business/event/article_event.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/business/state/app_state.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppState.none) {
    on<AppStarted>(_onAppStarted);
  }
  Future<void> _onAppStarted(AppEvent event, Emitter<AppState> emitter) async {
    emitter(AppState.started);
    Logger().d('app started from app bloc');
  }
}
