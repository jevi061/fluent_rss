import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';

class FeedState extends Equatable {
  List<Article> all = [];
  List<Article> unread = [];
  List<Article> today = [];
  FeedState.initial();
  FeedState({required this.all, required this.unread, required this.today});
  @override
  List<Object?> get props => [all, unread, today];
}
