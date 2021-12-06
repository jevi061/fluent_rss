import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';

class HistoryState extends Equatable {
  List<Article> articles = [];
  HistoryState.ready({required this.articles});
  @override
  List<Object?> get props => [articles];
}
