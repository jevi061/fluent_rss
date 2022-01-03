import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/article.dart';

abstract class CategoryEvent extends Equatable {}

class CategoryStarted extends CategoryEvent {
  @override
  List<Object?> get props => [];
}

class CategoryAdded extends CategoryEvent {
  @override
  List<Object?> get props => [];
}

class CreateCategoryActionExecuted extends CategoryEvent {
  String category;
  CreateCategoryActionExecuted(this.category);
  @override
  List<Object?> get props => [category];
}

class CategoryDeleted extends CategoryEvent {
  @override
  List<Object?> get props => [];
}
