import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';

abstract class ReadingEvent extends Equatable {}

class ReadingStarted extends ReadingEvent {
  Article article;
  ReadingStarted({required this.article});
  @override
  List<Object?> get props => [article];
}

class ReadingOutdated extends ReadingEvent {
  Article article;
  ReadingOutdated({required this.article});
  @override
  List<Object?> get props => [article];
}
