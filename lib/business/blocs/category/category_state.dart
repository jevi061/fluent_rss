import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/category.dart';

abstract class CategoryState extends Equatable {}

class CategoryReadyState extends CategoryState {
  final List<Category> all;
  CategoryReadyState.ready({required this.all});
  @override
  List<Object?> get props => [all];
}

class CategoryListResponsedState extends CategoryState {
  final List<Category> all;
  CategoryListResponsedState.ready({required this.all});
  @override
  List<Object?> get props => [all];
}
