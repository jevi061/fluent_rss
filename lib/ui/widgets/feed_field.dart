import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_rss/business/bloc/add_channel_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/event/add_channel_event.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedField extends StatelessWidget {
  final TextEditingController urlController = TextEditingController();
  Channel? channel;

  FeedField({Key? key, this.channel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                maxLines: 2,
                controller: urlController..text = channel?.link ?? '',
                autofocus: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        BlocProvider.of<AddChannelBloc>(context).add(
                            ChannelSubmited(
                                channelLink: urlController.text,
                                categoryId: 1));
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
                          icon: const Icon(Icons.add)),
                    ],
                  ),
                ),
              ),
            ]
          ],
        ));
  }
}
