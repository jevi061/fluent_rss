import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/state/channel_state.dart';
import 'package:fluent_rss/ui/widgets/channel_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelPanel extends StatelessWidget {
  int categoryId;

  ChannelPanel({Key? key, required this.categoryId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelBloc, ChannelState>(
        buildWhen: (previous, current) => current is ChannelReadyState,
        builder: (context, state) {
          if (state is ChannelReadyState) {
            if (state.channels.isEmpty) {
              return Text("No channels in this category");
            }
            var list = state.channels
                .where((element) => element.categoryId == categoryId)
                .toList();
            return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return ChannelTile(channel: list[index]);
                });
          }
          return Text("something went wrong");
        });
  }
}