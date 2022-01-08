import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';

class TodayFeedState extends Equatable {
  final List<Article> articles;
  TodayFeedState(this.articles);
  @override
  List<Object?> get props => [articles];
}
