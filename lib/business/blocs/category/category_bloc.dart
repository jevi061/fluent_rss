import 'dart:async';

import 'package:fluent_rss/business/blocs/category/category_event.dart';
import 'package:fluent_rss/business/blocs/category/category_state.dart';
import 'package:fluent_rss/data/domains/category.dart';
import 'package:fluent_rss/data/repository/category_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryRepository categoryRepository;
  CategoryBloc({required this.categoryRepository})
      : super(CategoryReadyState.ready(all: [])) {
    on<CategoryStarted>(_onCategoryStarted);
    on<CategoryCreateActionExecuted>(_onCreateCategoryActionExecuted);
    on<CategoryDeleteActionTriggered>(_onDeleteCategoryActionTrigged);
    on<CategoryListRequested>(_onCategoryListRequested);
    on<CategoryOutdated>(_onCategoryOutdated);
  }
  Future<void> _onCategoryStarted(
      CategoryStarted event, Emitter<CategoryState> emitter) async {
    var all = await categoryRepository.getCategories();
    emitter(CategoryReadyState.ready(all: all));
  }

  Future<void> _onCategoryListRequested(
      CategoryListRequested event, Emitter<CategoryState> emitter) async {
    var all = await categoryRepository.getCategories();
    emitter(CategoryListResponsedState.ready(all: all));
  }

  Future<void> _onCreateCategoryActionExecuted(
      CategoryCreateActionExecuted event,
      Emitter<CategoryState> emitter) async {
    await categoryRepository.addCategory(Category(name: event.category));
    var all = await categoryRepository.getCategories();
    emitter(CategoryReadyState.ready(all: all));
  }

  Future<void> _onDeleteCategoryActionTrigged(
      CategoryDeleteActionTriggered event,
      Emitter<CategoryState> emitter) async {
    if (event.category.id != null) {
      await categoryRepository.deleteCategory(event.category.id!);
      var all = await categoryRepository.getCategories();
      emitter(CategoryReadyState.ready(all: all));
    }
  }

  Future<void> _onCategoryOutdated(
      CategoryOutdated event, Emitter<CategoryState> emitter) async {
    var all = await categoryRepository.getCategories();
    emitter(CategoryReadyState.ready(all: all));
  }
}
