import 'dart:async';

import 'package:fluent_rss/business/event/category_event.dart';
import 'package:fluent_rss/business/state/category_state.dart';
import 'package:fluent_rss/data/repository/category_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryRepository categoryRepository;
  CategoryBloc({required this.categoryRepository})
      : super(CategoryReadyState.ready(all: [])) {
    on<CategoryStarted>(_onCategoryStarted);
  }
  Future<void> _onCategoryStarted(
      CategoryStarted event, Emitter<CategoryState> emitter) async {
    var all = await categoryRepository.getAll();
    emitter(CategoryReadyState.ready(all: all));
  }
}
