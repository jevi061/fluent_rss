import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/state/channel_state.dart';
import 'package:fluent_rss/ui/widgets/channel_delegate.dart';
import 'package:fluent_rss/ui/widgets/channel_tile.dart';
import 'package:fluent_rss/ui/widgets/menu_item.dart';
import 'package:fluent_rss/ui/widgets/menu_sheet.dart';
import 'package:fluent_rss/ui/widgets/refresh_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelScreen extends StatelessWidget {
  ChannelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Fluent RSS"),
            actions: [RefreshButton(), MenuSheet()]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showSearch(context: context, delegate: ChannelSearchDelegate([]));
          },
          child: const Icon(Icons.search),
        ),
        body: BlocConsumer<ChannelBloc, ChannelState>(
          buildWhen: (previous, current) => current is ChannelReadyState,
          builder: (context, state) {
            if (state is ChannelReadyState) {
              return state.channels.isEmpty
                  ? const Center(
                      child: Text('Add or import channel from top menu'),
                    )
                  : Scrollbar(
                      child: ListView.builder(
                          itemCount: state.channels.length,
                          itemBuilder: (context, index) {
                            return ChannelTile(channel: state.channels[index]);
                          }));
            }
            return const Text("something went wrong");
          },
          listener: (context, state) {
            if (state is ChannelsExportedState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('export opml finished!')));
            }
          },
        ));
  }
}
