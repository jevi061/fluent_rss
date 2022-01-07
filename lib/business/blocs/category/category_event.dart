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

class CategoryCreateActionExecuted extends CategoryEvent {
  final String category;
  CategoryCreateActionExecuted(this.category);
  @override
  List<Object?> get props => [category];
}

class CategoryDeleteActionTriggered extends CategoryEvent {
  final Category category;
  CategoryDeleteActionTriggered(this.category);
  @override
  List<Object?> get props => [category];
}
