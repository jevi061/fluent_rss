import 'package:file_picker/file_picker.dart';
import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/event/channel_event.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/services/opml_parser.dart';
import 'package:fluent_rss/ui/screens/add_channel_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class Menu extends StatelessWidget {
  Menu();
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          ChannelBloc channelBloc = BlocProvider.of<ChannelBloc>(context);
          Logger().d('channelBloc:$channelBloc,${channelBloc.isClosed}');
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return BlocProvider.value(
                  value: channelBloc,
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(Icons.add),
                        title: Text('Add'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddChannelScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.import_export),
                        onTap: () async {
                          Navigator.pop(context);
                          // get file
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                  type: FileType.any, allowMultiple: false);
                          var path = result?.files.first.path;
                          var parser = OPMLParser();
                          List<Channel> parsedChannels =
                              await parser.parseURL(path!);
                          channelBloc.add(ChannelImported(parsedChannels));
                        },
                        title: Text('Import'),
                      ),
                      ListTile(
                        leading: Icon(Icons.import_export),
                        title: Text('Export'),
                      ),
                    ],
                  ),
                );
              });
        },
        icon: const Icon(Icons.more_vert));
  }
}
