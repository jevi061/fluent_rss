import 'dart:convert';

import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/services/feed_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AddChannelScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddChannelScreenState();
}

class _AddChannelScreenState extends State<AddChannelScreen> {
  Channel? channel;
  final urlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input your feed url"),
      ),
      body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                  controller: urlController,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          var feedParser = FeedParser();
                          var ch =
                              await feedParser.parseChannel(urlController.text);
                          Logger().d(
                              'channel title:${ch?.title},icon:${ch?.iconUrl}');
                          setState(() {
                            channel = ch;
                          });
                        },
                      ))),
              if (channel != null) ...[
                Card(
                  margin: EdgeInsets.only(top: 20),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              CachedNetworkImageProvider(channel!.iconUrl),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          channel!.title,
                          style: TextStyle(fontSize: 20),
                        )),
                        IconButton(
                            onPressed: () {
                              BlocProvider.of<ChannelBloc>(context)
                                  .add(ChannelAdded(channel!));
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.add)),
                      ],
                    ),
                  ),
                ),
              ]
            ],
          )),
    );
  }
}
