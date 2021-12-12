import 'dart:async';

import 'package:fluent_rss/business/event/app_event.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/business/event/reading_event.dart';
import 'package:fluent_rss/business/state/app_state.dart';
import 'package:fluent_rss/business/state/channel_state.dart';
import 'package:fluent_rss/business/state/reading_state.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'app_bloc.dart';

class ReadingBloc extends Bloc<ReadingEvent, ReadingState> {
  ReadingBloc() : super(ReadingState()) {
    on<ReadingStarted>(_onReadingStarted);
  }

  Future<void> _onReadingStarted(
      ReadingStarted event, Emitter<ReadingState> emitter) async {
    emitter(ReadingState(article: event.article));
  }
}
