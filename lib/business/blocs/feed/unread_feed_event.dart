import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';

abstract class UnreadFeedEvent extends Equatable {}

class UnreadFeedStarted extends UnreadFeedEvent {
  UnreadFeedStarted();
  @override
  List<Object?> get props => [];
}

class UnreadFeedLoadTriggered extends UnreadFeedEvent {
  UnreadFeedLoadTriggered();
  @override
  List<Object?> get props => [];
}
