import 'package:bloc/bloc.dart';
import 'package:fluent_rss/business/event/add_channel_event.dart';
import 'package:fluent_rss/business/state/add_channel_state.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:fluent_rss/services/feed_parser.dart';

class AddChannelBloc extends Bloc<AddChannelEvent, AddChannelState> {
  AddChannelBloc() : super(AddChannelStartedState()) {
    on<ChannelSubmited>(_onChannelSubmited);
  }
  Future<void> _onChannelSubmited(
      ChannelSubmited event, Emitter<AddChannelState> emitter) async {
    emitter(ChannelParsingState());
    var ch = await FeedParser.parseChannel(event.channelLink);
    ch?.categoryId = event.categoryId;
    AppLogger.instance.d('channel title:${ch?.title},icon:${ch?.iconUrl}');
    if (ch == null || ch.link.isEmpty) {
      emitter(AddChannelErrorState('invalid channel url'));
    } else {
      emitter(AddChannelReadyState(ch));
    }
  }
}
