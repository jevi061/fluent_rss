import 'package:equatable/equatable.dart';

abstract class AddChannelEvent extends Equatable {}

class ChannelSubmited extends AddChannelEvent {
  String link;
  ChannelSubmited(this.link);
  @override
  List<Object?> get props => [link];
}
