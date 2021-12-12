import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';

class ArticleState extends Equatable {
  List<Article> articles = [];
  ArticleState.ready({required this.articles});
  @override
  List<Object?> get props => [articles];
}
