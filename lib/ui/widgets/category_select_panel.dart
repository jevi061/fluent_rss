import 'package:fluent_rss/business/blocs/category/category_bloc.dart';
import 'package:fluent_rss/business/blocs/category/category_state.dart';
import 'package:fluent_rss/data/domains/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnSelect = void Function(Category);

class CategorySelectPanel extends StatelessWidget {
  OnSelect onSelect;
  CategorySelectPanel({Key? key, required this.onSelect}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
        buildWhen: (previous, current) => current is CategoryListResponsedState,
        builder: (context, state) {
          if (state is CategoryListResponsedState) {
            return ListView.builder(
                itemCount: state.all.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.all[index].name),
                    onTap: () => onSelect(state.all[index]),
                  );
                });
          }
          return Text("wrong");
        });
  }
}
