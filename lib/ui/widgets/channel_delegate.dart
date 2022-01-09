import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/data/repository/channel_repository.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:fluent_rss/ui/widgets/channel_tile.dart';
import 'package:flutter/material.dart';

class ChannelSearchDelegate extends SearchDelegate {
  ChannelRepository repository;
  ChannelSearchDelegate(this.repository);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Channel>>(
        future: repository.searchChannels(query),
        builder: (context, snap) {
          if (snap.hasData) {
            return Scrollbar(
                child: ListView.builder(
                    itemCount: snap.data?.length,
                    itemBuilder: (context, index) {
                      return ChannelTile(channel: snap.data![index]);
                    }));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: repository.searchChannelTitles(query),
        builder: (context, snap) {
          if (snap.hasData) {
            return Scrollbar(
                child: ListView.builder(
                    itemCount: snap.data?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snap.data?[index] ?? ""),
                        onTap: () {
                          query = snap.data?[index] ?? "";
                          showResults(context);
                        },
                      );
                    }));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
