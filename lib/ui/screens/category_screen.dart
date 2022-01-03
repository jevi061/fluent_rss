import 'package:fluent_rss/business/bloc/category_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/state/category_state.dart';
import 'package:fluent_rss/business/state/channel_state.dart';
import 'package:fluent_rss/data/domains/category.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/ui/widgets/channel_delegate.dart';
import 'package:fluent_rss/ui/widgets/channel_panel.dart';
import 'package:fluent_rss/ui/widgets/channel_tile.dart';
import 'package:fluent_rss/ui/widgets/create_category_action.dart';
import 'package:fluent_rss/ui/widgets/export_snacker.dart';
import 'package:fluent_rss/ui/widgets/menu_item.dart';
import 'package:fluent_rss/ui/widgets/menu_sheet.dart';
import 'package:fluent_rss/ui/widgets/refresh_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

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
              return state.all.isEmpty
                  ? const Center(
                      child: Text('Add or import channel from top menu'),
                    )
                  : Scrollbar(
                      controller: ScrollController(),
                      child: ListView.builder(
                          itemCount: state.all.length,
                          itemBuilder: (context, index) {
                            var item = state.all[index];
                            if (item is Category) {
                              return ExpansionTile(
                                title: Text(item.name),
                                children: [
                                  ChannelPanel(categoryId: item.id!),
                                ],
                              );
                            }
                            return ChannelTile(channel: item as Channel);
                          }));
            }
            return Text("something went wrong");
          },
        ));
  }
}
