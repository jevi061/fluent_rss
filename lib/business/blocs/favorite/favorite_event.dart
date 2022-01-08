import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';

abstract class FavoriteEvent extends Equatable {}

class FavoriteOutdated extends FavoriteEvent {
  FavoriteOutdated();
  @override
  List<Object?> get props => [];
}

class FavoriteStarted extends FavoriteEvent {
  @override
  List<Object?> get props => [];
}
