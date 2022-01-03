import 'package:fluent_rss/business/bloc/category_bloc.dart';
import 'package:fluent_rss/business/event/category_event.dart';
import 'package:fluent_rss/ui/widgets/category_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCategoryAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return CategoryDialog();
              });
        },
        icon: Icon(Icons.create_new_folder_outlined));
  }
}
