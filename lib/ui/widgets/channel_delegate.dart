import 'package:fluent_rss/data/domains/channel.dart';
import 'package:fluent_rss/ui/widgets/channel_tile.dart';
import 'package:flutter/material.dart';

class ChannelSearchDelegate extends SearchDelegate {
  List<Channel> channels;
  ChannelSearchDelegate(this.channels);
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
    var results = channels.where((ch) => ch.title.contains(query)).toList();
    return Scrollbar(
        child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return ChannelTile(channel: results[index]);
            }));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = channels.where((ch) => ch.title.contains(query)).toList();
    return Scrollbar(
        child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ChannelTile(channel: suggestions[index]);
            }));
  }
}
