import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/channel.dart';

abstract class ChannelState extends Equatable {}

class ChannelReadyState extends ChannelState {
  List<Channel> channels;
  ChannelReadyState({required this.channels});
  @override
  List<Object?> get props => [channels];
}

class ChannelRefreshedState extends ChannelState {
  Channel channel;
  ChannelRefreshedState(this.channel);
  @override
  List<Object?> get props => [channel];
}

class AllChannelsRefreshedState extends ChannelState {
  AllChannelsRefreshedState();
  @override
  List<Object?> get props => [];
}

class PartialChannelsRefreshedState extends ChannelState {
  PartialChannelsRefreshedState();
  @override
  List<Object?> get props => [];
}

class ChannelRefreshingState extends ChannelState {
  final double progress;
  ChannelRefreshingState({required this.progress});
  @override
  List<Object?> get props => [progress];
}

class ChannelsExportedState extends ChannelState {
  final String path;
  final DateTime exportedAt;
  ChannelsExportedState({required this.path, required this.exportedAt});
  @override
  List<Object?> get props => [path, exportedAt];
}
