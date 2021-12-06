import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';

abstract class FavoriteEvent extends Equatable {}

class FavoriteUpdated extends FavoriteEvent {
  Article article;
  FavoriteUpdated({required this.article});
  @override
  List<Object?> get props => [];
}

class FavoriteStarted extends FavoriteEvent {
  @override
  List<Object?> get props => [];
}
