import 'package:fluent_rss/business/blocs/category/category_bloc.dart';
import 'package:fluent_rss/business/blocs/category/category_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryDialog extends StatelessWidget {
  final TextEditingController tfController = TextEditingController();

  CategoryDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Input category name below"),
      content: TextField(
        autofocus: true,
        controller: tfController,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          }, // function used to perform after pressing the button
          child: Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            if (tfController.text.isNotEmpty) {
              BlocProvider.of<CategoryBloc>(context)
                  .add(CreateCategoryActionExecuted(tfController.text));
            }
            Navigator.pop(context);
          },
          child: Text('ACCEPT'),
        ),
      ],
    );
  }
}
