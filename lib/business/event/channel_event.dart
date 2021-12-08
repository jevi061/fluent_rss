import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/channel.dart';

abstract class ChannelEvent extends Equatable {}

class ChannelReady extends ChannelEvent {
  @override
  List<Object?> get props => [];
}

class ChannelUpdated extends ChannelEvent {
  @override
  List<Object?> get props => [];
}

class ChannelStarted extends ChannelEvent {
  @override
  List<Object?> get props => [];
}

class ChannelOpened extends ChannelEvent {
  Channel channel;
  ChannelOpened(this.channel);
  @override
  List<Object?> get props => [channel];
}

class ChannelRefreshed extends ChannelEvent {
  Channel channel;
  ChannelRefreshed(this.channel);
  @override
  List<Object?> get props => [channel];
}
