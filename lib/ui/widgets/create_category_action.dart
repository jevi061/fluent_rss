import 'package:fluent_rss/ui/widgets/category_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
