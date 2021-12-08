import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';

class ArticleState extends Equatable {
  Channel channel;
  List<Article> articles = [];
  ArticleState.ready({required this.channel, required this.articles});
  @override
  List<Object?> get props => [channel, articles];
}
