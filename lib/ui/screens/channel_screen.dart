import 'package:fluent_rss/business/bloc/channel_bloc.dart';
import 'package:fluent_rss/business/state/channel_state.dart';
import 'package:fluent_rss/ui/screens/article_screen.dart';
import 'package:fluent_rss/ui/screens/reading_screen.dart';
import 'package:fluent_rss/ui/widgets/channel_searcher.dart';
import 'package:fluent_rss/ui/widgets/channel_tile.dart';
import 'package:fluent_rss/ui/widgets/opml_picker.dart';
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
          actions: [ChannelSearcher(), OPMLPicker()],
        ),
        body: BlocBuilder<ChannelBloc, ChannelState>(
            builder: (BuildContext context, ChannelState state) {
          if (state.channels.isEmpty) {
            return Text('Waiting...');
          } else {
            return ListView.builder(
                itemCount: state.channels.length,
                itemBuilder: (context, index) => ChannelTile(
                      channel: state.channels[index],
                    ));
          }
        }));
  }
}

class ChannelPage extends StatelessWidget {
  ChannelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return ChannelScreen();
                case '/articles':
                  return ArticleScreen();
                case '/reading':
                  return ReadingScreen();
                default:
                  return Text("invalid route");
              }
            });
      },
    );
  }
}
