import 'package:fluent_rss/business/blocs/channel/channel_bloc.dart';
import 'package:fluent_rss/business/blocs/channel/channel_event.dart';
import 'package:fluent_rss/business/blocs/channel/channel_state.dart';
import 'package:fluent_rss/services/app_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';

class RefreshButton extends StatelessWidget {
  RefreshButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChannelBloc, ChannelState>(builder: (context, state) {
      AppLogger.instance.d('state type is:${state.runtimeType}');
      if (state is ChannelRefreshingState) {
        AppLogger.instance.d('new progress is:${state.progress}');
        return Container(
          width: 20,
          height: 20,
          child: CircularPercentIndicator(
            lineWidth: 3,
            radius: 20,
            percent: state.progress,
            progressColor: Colors.white,
          ),
        );
      }
      return IconButton(
          onPressed: () {
            BlocProvider.of<ChannelBloc>(context)
                .add(AllChannelsRefreshStarted());
          },
          icon: const Icon(Icons.refresh));
    });
  }
}
