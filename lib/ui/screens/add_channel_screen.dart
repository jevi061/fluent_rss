import 'dart:convert';

import 'package:fluent_rss/business/blocs/channel/add_channel_bloc.dart';
import 'package:fluent_rss/business/blocs/channel/channel_bloc.dart';
import 'package:fluent_rss/business/blocs/channel/add_channel_event.dart';
import 'package:fluent_rss/business/blocs/channel/channel_event.dart';
import 'package:fluent_rss/business/blocs/channel/add_channel_state.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/services/feed_parser.dart';
import 'package:fluent_rss/ui/widgets/feed_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AddChannelScreen extends StatelessWidget {
  AddChannelScreen({Key? key}) : super(key: key);
  final TextEditingController urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new feed"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(
              maxLines: 2,
              controller: urlController,
              autofocus: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      BlocProvider.of<AddChannelBloc>(context).add(
                          ChannelSubmited(
                              channelLink: urlController.text, categoryId: 1));
                    },
                  ))),
          ParsedChannelWidget(),
        ]),
      ),
    );
  }
}

class ParsedChannelWidget extends StatelessWidget {
  const ParsedChannelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: BlocConsumer<AddChannelBloc, AddChannelState>(
          builder: (context, state) {
        if (state is ChannelParsingState) {
          return const CircularProgressIndicator();
        } else if (state is AddChannelReadyState) {
          return Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(state.channel.iconUrl),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: Text(
                    state.channel.title,
                    style: TextStyle(fontSize: 20),
                  )),
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<ChannelBloc>(context)
                            .add(ChannelAdded(state.channel));
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.add)),
                ],
              ),
            ),
          );
        }
        return Container();
      }, listener: (context, state) {
        if (state is AddChannelErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('invalid feed url')));
        }
      }),
    );
  }
}
