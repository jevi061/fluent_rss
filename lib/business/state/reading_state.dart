import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';
import 'package:fluent_rss/data/domains/channel.dart';

class ReadingState extends Equatable {
  Article? article;
  ReadingState({this.article});

  @override
  List<Object?> get props => [article];
}
