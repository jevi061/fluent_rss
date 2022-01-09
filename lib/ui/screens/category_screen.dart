import 'package:fluent_rss/business/blocs/category/category_bloc.dart';
import 'package:fluent_rss/business/blocs/category/category_event.dart';
import 'package:fluent_rss/business/blocs/category/category_state.dart';
import 'package:fluent_rss/business/blocs/channel/channel_bloc.dart';
import 'package:fluent_rss/business/blocs/channel/channel_state.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:fluent_rss/ui/widgets/category_searchbar.dart';
import 'package:fluent_rss/ui/widgets/category_tile.dart';
import 'package:fluent_rss/ui/widgets/channel_delegate.dart';
import 'package:fluent_rss/ui/widgets/create_category_action.dart';
import 'package:fluent_rss/ui/widgets/menu_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Fluent RSS"),
            actions: [CreateCategoryAction(), MenuSheet()]),
        body: BlocListener<ChannelBloc, ChannelState>(
          listener: (context, state) {
            if (state is ChannelReadyState) {
              BlocProvider.of<CategoryBloc>(context).add(CategoryOutdated());
            }
          },
          child: BlocBuilder<CategoryBloc, CategoryState>(
            buildWhen: (previous, current) => current is CategoryReadyState,
            builder: (context, state) {
              if (state is CategoryReadyState) {
                return Scrollbar(
                    controller: ScrollController(),
                    child: ListView.builder(
                        itemCount: state.all.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return CategorySearchbar();
                          }
                          index = index - 1;
                          return CategoryTile(
                            category: state.all[index],
                          );
                        }));
              }
              return Text("something went wrong");
            },
          ),
        ));
  }
}
