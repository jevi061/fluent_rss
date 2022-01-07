import 'package:equatable/equatable.dart';

abstract class AddChannelEvent extends Equatable {}

class ChannelSubmited extends AddChannelEvent {
  String channelLink;
  int categoryId;
  ChannelSubmited({required this.channelLink, required this.categoryId});
  @override
  List<Object?> get props => [channelLink, categoryId];
}
