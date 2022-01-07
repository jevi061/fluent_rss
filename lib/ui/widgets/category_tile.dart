import 'package:fluent_rss/business/blocs/category/category_bloc.dart';
import 'package:fluent_rss/business/blocs/category/category_event.dart';
import 'package:fluent_rss/business/blocs/channel/channel_bloc.dart';
import 'package:fluent_rss/business/blocs/channel/channel_event.dart';
import 'package:fluent_rss/data/domains/category.dart';
import 'package:fluent_rss/router/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryTile extends StatelessWidget {
  Category category;
  CategoryTile({Key? key, required this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Slidable(
        key: Key(category.id.toString()),
        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                context
                    .read<CategoryBloc>()
                    .add(CategoryDeleteActionTriggered(category));
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'delete',
            ),
          ],
        ),
        child: Card(
            child: ListTile(
          title: Text(category.name),
          trailing: const Icon(Icons.arrow_forward),
          onTap: () {
            BlocProvider.of<ChannelBloc>(context)
                .add(ChannelRequested(category.id!));
            Navigator.of(context)
                .pushNamed(AppRouter.channelScreen, arguments: category);
          },
        )));
  }
}
