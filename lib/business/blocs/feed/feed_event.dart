import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';

abstract class FeedEvent extends Equatable {}

class AllFeedsStarted extends FeedEvent {
  AllFeedsStarted();
  @override
  List<Object?> get props => [];
}

class FeedsStateChanged extends FeedEvent {
  FeedsStateChanged();
  @override
  List<Object?> get props => [];
}
