import 'package:fluent_rss/business/bloc/category_bloc.dart';
import 'package:fluent_rss/business/event/category_event.dart';
import 'package:fluent_rss/business/state/category_state.dart';
import 'package:fluent_rss/ui/widgets/channel_delegate.dart';
import 'package:fluent_rss/ui/widgets/channel_panel.dart';
import 'package:fluent_rss/ui/widgets/create_category_action.dart';
import 'package:fluent_rss/ui/widgets/menu_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Fluent RSS"),
            actions: [CreateCategoryAction(), MenuSheet()]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showSearch(context: context, delegate: ChannelSearchDelegate([]));
          },
          child: const Icon(Icons.search),
        ),
        body: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryReadyState) {
              return Scrollbar(
                  controller: ScrollController(),
                  child: ListView.builder(
                      itemCount: state.all.length,
                      itemBuilder: (context, index) {
                        var item = state.all[index];

                        return Slidable(
                          child: Card(
                            child: ExpansionTile(
                              title: Text(item.name),
                              children: [
                                ChannelPanel(categoryId: item.id!),
                              ],
                            ),
                          ),
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (BuildContext context) {
                                  context
                                      .read<CategoryBloc>()
                                      .add(DeleteCategoryActionTriggered(item));
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                        );
                      }));
            }
            return Text("something went wrong");
          },
        ));
  }
}
