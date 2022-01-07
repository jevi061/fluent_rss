import 'dart:async';

import 'package:fluent_rss/business/blocs/app/app_event.dart';
import 'package:fluent_rss/business/blocs/app/app_state.dart';
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
