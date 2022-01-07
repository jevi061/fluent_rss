import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnSelect = void Function(bool);

class MultiSelectItem extends StatefulWidget {
  bool isSelecting;
  OnSelect onSelect;
  Widget child;
  MultiSelectItem(
      {required this.isSelecting, required this.onSelect, required this.child});

  @override
  State<MultiSelectItem> createState() => _MultiSelectItemState();
}

class _MultiSelectItemState extends State<MultiSelectItem> {
  bool _selected = false;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (widget.isSelecting)
        Checkbox(
            value: _selected,
            onChanged: (v) {
              setState(() {
                _selected = v ?? false;
                widget.onSelect(_selected);
              });
            }),
      Expanded(child: widget.child)
    ]);
  }
}
