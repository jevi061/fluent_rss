import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';

class AllFeedState extends Equatable {
  final List<Article> articles;
  AllFeedState(this.articles);
  @override
  List<Object?> get props => [articles];
}
