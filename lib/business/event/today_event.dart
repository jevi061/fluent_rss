import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';

abstract class TodayEvent extends Equatable {}

class TodayStarted extends TodayEvent {
  @override
  List<Object?> get props => [];
}

class TodayUpdated extends TodayEvent {
  List<Article> articles;
  TodayUpdated({required this.articles});
  @override
  List<Object?> get props => [articles];
}
