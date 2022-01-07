import 'dart:async';

import 'package:fluent_rss/business/blocs/read/reading_event.dart';
import 'package:fluent_rss/business/blocs/read/reading_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadingBloc extends Bloc<ReadingEvent, ReadingState> {
  ReadingBloc() : super(ReadingState()) {
    on<ReadingStarted>(_onReadingStarted);
  }

  Future<void> _onReadingStarted(
      ReadingStarted event, Emitter<ReadingState> emitter) async {
    emitter(ReadingState(article: event.article));
  }
}
