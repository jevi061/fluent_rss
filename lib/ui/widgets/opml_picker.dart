import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_rss/business/bloc/article_bloc.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/event/article_event.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/services/opml_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OPMLPicker extends StatelessWidget {
  const OPMLPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          // get file
          FilePickerResult? result = await FilePicker.platform
              .pickFiles(type: FileType.any, allowMultiple: false);
          var path = result?.files.first.path;
          var parser = OPMLParser();
          List<Channel> parsedChannels = await parser.parseURL(path!);
          await context
              .read<ChannelBloc>()
              .channelRepository
              .addChannels(parsedChannels);
          context.read<ChannelBloc>().add(ChannelUpdated());
          context.read<ArticleBloc>().add(ArticleChannelUpdated());
        },
        icon: const Icon(Icons.add));
  }
}
