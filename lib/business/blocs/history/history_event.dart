import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';

abstract class HistoryEvent extends Equatable {}

class HistoryOutdated extends HistoryEvent {
  HistoryOutdated();
  @override
  List<Object?> get props => [];
}

class HistoryStarted extends HistoryEvent {
  @override
  List<Object?> get props => [];
}
