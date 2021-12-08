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
