import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/channel.dart';

abstract class ChannelEvent extends Equatable {}

class ChannelReady extends ChannelEvent {
  @override
  List<Object?> get props => [];
}

class ChannelUpdated extends ChannelEvent {
  List<Channel> channels;
  ChannelUpdated(this.channels);
  @override
  List<Object?> get props => [channels];
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

class ChannelStatusChanged extends ChannelEvent {
  @override
  List<Object?> get props => [];
}

class PartialChannelRefreshStarted extends ChannelEvent {
  final List<Channel> channels;
  PartialChannelRefreshStarted(this.channels);
  @override
  List<Object?> get props => [channels];
}

class PartialChannelRefreshFinished extends ChannelEvent {
  PartialChannelRefreshFinished();
  @override
  List<Object?> get props => [];
}

class ChannelRefreshStarted extends ChannelEvent {
  ChannelRefreshStarted();
  @override
  List<Object?> get props => [];
}

class ChannelRefreshFinished extends ChannelEvent {
  ChannelRefreshFinished();
  @override
  List<Object?> get props => [];
}

class ChannelDeleted extends ChannelEvent {
  Channel channel;
  ChannelDeleted(this.channel);
  @override
  List<Object?> get props => [channel];
}

class ChannelAdded extends ChannelEvent {
  Channel channel;
  ChannelAdded(this.channel);
  @override
  List<Object?> get props => [channel];
}

class ChannelImported extends ChannelEvent {
  List<Channel> channels;
  ChannelImported(this.channels);
  @override
  List<Object?> get props => [channels];
}

class ChannelsExportStarted extends ChannelEvent {
  String path;
  ChannelsExportStarted(this.path);
  @override
  List<Object?> get props => [path];
}

class ChannelsExportFinished extends ChannelEvent {
  ChannelsExportFinished();
  @override
  List<Object?> get props => [];
}
