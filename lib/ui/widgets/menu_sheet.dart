import 'package:file_picker/file_picker.dart';
import 'package:fluent_rss/business/blocs/channel/channel_bloc.dart';
import 'package:fluent_rss/business/blocs/channel/channel_event.dart';
import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/services/opml_parser.dart';
import 'package:fluent_rss/ui/screens/add_channel_screen.dart';
import 'package:fluent_rss/ui/widgets/menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class MenuSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          ChannelBloc channelBloc = BlocProvider.of<ChannelBloc>(context);
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return BlocProvider.value(
                    value: channelBloc,
                    child: Theme(
                      child: ListView(
                        children: [
                          Text(
                            "Fluent RSS",
                            style: Theme.of(context).textTheme.headline3,
                            textAlign: TextAlign.center,
                          ),
                          MenuItem(
                            iconData: Icons.add,
                            title: "Add",
                            subtitle: "add a rss or an atom feed",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddChannelScreen()),
                              );
                            },
                          ),
                          MenuItem(
                            iconData: Icons.import_contacts,
                            title: "Import",
                            subtitle: "import feeds from OPML",
                            onTap: () async {
                              Navigator.pop(context);
                              // get file
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                      type: FileType.any, allowMultiple: false);
                              if (result?.files.isEmpty ?? true) {
                                return;
                              }
                              var path = result?.files.first.path;
                              var parser = OPMLParser();
                              List<Object> parsedChannels =
                                  await parser.parseURL(path!);
                              channelBloc.add(ChannelImported(parsedChannels));
                            },
                          ),
                          MenuItem(
                            iconData: Icons.exit_to_app,
                            title: "Export",
                            subtitle: "export feeds to OPML",
                            onTap: () async {
                              if (Platform.isIOS || Platform.isAndroid) {
                                bool status =
                                    await Permission.storage.isGranted;
                                if (!status) await Permission.storage.request();
                              }
                              bool status = await Permission.storage.isGranted;
                              if (status) {
                                channelBloc.add(ChannelsExportStarted());
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                      data: Theme.of(context),
                    ));
              });
        },
        icon: const Icon(Icons.more_vert));
  }
}
