import 'package:fluent_rss/business/blocs/channel/channel_bloc.dart';
import 'package:fluent_rss/business/blocs/channel/channel_state.dart';
import 'package:fluent_rss/data/domains/category.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:fluent_rss/ui/widgets/channel_delegate.dart';
import 'package:fluent_rss/ui/widgets/channel_tile.dart';
import 'package:fluent_rss/ui/widgets/menu_sheet.dart';
import 'package:fluent_rss/ui/widgets/multi_select_item.dart';
import 'package:fluent_rss/ui/widgets/refresh_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class ChannelScreen extends StatefulWidget {
  ChannelScreen({Key? key}) : super(key: key);

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  Set<int> selectedItem = {};
  bool isSelecting = false;

  @override
  Widget build(BuildContext context) {
    Category category = ModalRoute.of(context)?.settings.arguments as Category;
    return Scaffold(
        appBar: AppBar(title: Text(category.name), actions: [
          RefreshButton(),
          IconButton(
              onPressed: () {
                setState(() {
                  isSelecting = !isSelecting;
                });
              },
              icon: Icon(Icons.mode_edit)),
          MenuSheet()
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showSearch(context: context, delegate: ChannelSearchDelegate([]));
          },
          child: const Icon(Icons.search),
        ),
        bottomNavigationBar: isSelecting
            ? BottomAppBar(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () {}, child: Text("move")),
                  TextButton(onPressed: () {}, child: Text("delete"))
                ],
              ))
            : null,
        body: BlocConsumer<ChannelBloc, ChannelState>(
          buildWhen: (previous, current) => current is ChannelReadyState,
          builder: (context, state) {
            if (state is ChannelReadyState) {
              return state.channels.isEmpty
                  ? const Center(
                      child: Text('Add or import channel from top menu'),
                    )
                  : Scrollbar(
                      controller: ScrollController(),
                      child: ListView.builder(
                          itemCount: state.channels.length,
                          itemBuilder: (context, index) {
                            return MultiSelectItem(
                                isSelecting: isSelecting,
                                onSelect: (bool selected) {
                                  selected
                                      ? selectedItem.add(index)
                                      : selectedItem.remove(index);
                                },
                                child: ChannelTile(
                                  channel: state.channels[index],
                                ));
                          }));
            }
            return const Text("something went wrong");
          },
          listener: (context, state) {
            if (state is ChannelsExportedState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("OPML file"),
                action: SnackBarAction(
                  label: "share",
                  onPressed: () async {
                    await Share.shareFiles([state.path + "/fluent_rss.opml"],
                        mimeTypes: ["application/xml"]);
                  },
                ),
              ));
            }
          },
        ));
  }
}
