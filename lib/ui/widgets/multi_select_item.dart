import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef VoidCallback = void Function();

class MultiSelectItem extends StatefulWidget {
  bool isSelecting;
  VoidCallback onSelect;
  Widget child;
  MultiSelectItem({
    Key? key,
    required this.isSelecting,
    required this.onSelect,
    required this.child,
  }) : super(key: key);

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
                widget.onSelect();
              });
            }),
      Expanded(child: widget.child)
    ]);
  }
}

class MultiSelectController {
  List<int> selectedIndexes = [];
  bool isSelecting = false;
  int listLength = 0;

  /// Sets the controller length
  void set(int i) {
    listLength = i;
    isSelecting = false;
    selectedIndexes.clear();
  }

  /// Returns true if the id is selected
  bool isSelected(int i) {
    return selectedIndexes.contains(i);
  }

  /// Toggle all select.
  /// If there are some that not selected, it will select all.
  /// If not, it will deselect all.
  void toggleAll() {
    if (selectedIndexes.length == listLength) {
      deselectAll();
    } else {
      selectAll();
    }
  }

  /// Select all
  void selectAll() {
    isSelecting = true;
    selectedIndexes = List.generate(listLength, (index) {
      return index;
    });
  }

  /// Deselect all
  void deselectAll() {
    selectedIndexes.clear();
  }

  /// Toggle at index
  void toggle(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
  }

  /// Select at index
  void select(int index) {
    if (!selectedIndexes.contains(index)) {
      selectedIndexes.add(index);
    }
    isSelecting = true;
  }

  /// Deselect at index
  void deselect(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    }
  }
}
