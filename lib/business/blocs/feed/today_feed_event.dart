import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';

abstract class TodayFeedEvent extends Equatable {}

class TodayFeedStarted extends TodayFeedEvent {
  TodayFeedStarted();
  @override
  List<Object?> get props => [];
}

class TodayFeedLoadTriggered extends TodayFeedEvent {
  TodayFeedLoadTriggered();
  @override
  List<Object?> get props => [];
}
