import 'package:equatable/equatable.dart';
import 'package:fluent_rss/data/domains/channel.dart';

class ChannelState extends Equatable {
  List<Channel> channels = [];
  ChannelState.ready({required this.channels});
  @override
  // TODO: implement props
  List<Object?> get props => [channels];
}
