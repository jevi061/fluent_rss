import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/channel.dart';

abstract class AddChannelState extends Equatable {}

class AddChannelStartedState extends AddChannelState {
  @override
  List<Object?> get props => [];
}

class AddChannelErrorState extends AddChannelState {
  final String errMessage;
  AddChannelErrorState(this.errMessage);
  @override
  List<Object?> get props => [errMessage];
}

class AddChannelReadyState extends AddChannelState {
  final Channel channel;
  AddChannelReadyState(this.channel);
  @override
  List<Object?> get props => [channel];
}

class ChannelParsingState extends AddChannelState {
  @override
  List<Object?> get props => [];
}
