import 'package:fluent_rss/business/bloc/reading_bloc.dart';
import 'package:fluent_rss/business/state/reading_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReadingScreen extends StatefulWidget {
  ReadingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadingScreen> {
  double loadProgress = 10;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReadingBloc, ReadingState>(
        builder: (BuildContext context, ReadingState state) {
      return Scaffold(
          appBar: AppBar(title: Text(state.article?.title ?? "")),
          body: Stack(
            children: [
              WebView(
                initialUrl: state.article?.link ?? "",
                onProgress: (int progress) {
                  setState(() {
                    Logger().d("loading progress:$progress");
                    loadProgress = progress.toDouble();
                  });
                },
                onPageFinished: (url) {
                  setState(() {
                    loadProgress = 100.0;
                  });
                },
              ),
              loadProgress == 100
                  ? Stack()
                  : LinearProgressIndicator(
                      value: loadProgress / 100,
                    ),
            ],
          ));
    });
  }
}
