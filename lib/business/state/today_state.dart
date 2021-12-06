import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';

class TodayState extends Equatable {
  List<Article> articles = [];
  TodayState.ready({required this.articles});
  @override
  List<Object?> get props => [articles];
}
