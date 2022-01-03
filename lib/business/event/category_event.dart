import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/category.dart';

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

class DeleteCategoryActionTriggered extends CategoryEvent {
  Category category;
  DeleteCategoryActionTriggered(this.category);
  @override
  List<Object?> get props => [category];
}
