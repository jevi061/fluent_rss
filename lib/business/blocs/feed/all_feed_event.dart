import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';

abstract class AllFeedEvent extends Equatable {}

class AllFeedStarted extends AllFeedEvent {
  AllFeedStarted();
  @override
  List<Object?> get props => [];
}

class AllFeedLoadTriggered extends AllFeedEvent {
  AllFeedLoadTriggered();
  @override
  List<Object?> get props => [];
}
