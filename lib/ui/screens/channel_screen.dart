import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/state/channel_state.dart';
import 'package:fluent_rss/ui/widgets/channel_delegate.dart';
import 'package:fluent_rss/ui/widgets/channel_tile.dart';
import 'package:fluent_rss/ui/widgets/menu_item.dart';
import 'package:fluent_rss/ui/widgets/menu_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelScreen extends StatelessWidget {
  ChannelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelBloc, ChannelState>(
        builder: (BuildContext context, ChannelState state) {
      ChannelReadyState newState = state as ChannelReadyState;
      return Scaffold(
          appBar:
              AppBar(title: const Text("Fluent RSS"), actions: [MenuSheet()]),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: ChannelSearchDelegate(newState.channels));
            },
            child: const Icon(Icons.search),
          ),
          body: newState.channels.isEmpty
              ? const Center(
                  child: Text('Add or import channel from top menu'),
                )
              : Scrollbar(
                  child: ListView.builder(
                      itemCount: newState.channels.length,
                      itemBuilder: (context, index) {
                        return ChannelTile(channel: newState.channels[index]);
                      })));
    });
  }
}
