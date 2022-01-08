import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';

class UnreadFeedState extends Equatable {
  final List<Article> articles;
  UnreadFeedState(this.articles);
  @override
  List<Object?> get props => [articles];
}
