/// Tab selector widget

import 'package:flutter/cupertino.dart';
import 'package:get_fit/tabs/tab.dart';

class TabSelector extends StatelessWidget {
  const TabSelector(
      {Key? key,
      required this.titles,
      required this.activeTab,
      required this.onSelect})
      : super(key: key);
  final List<String> titles;
  final String activeTab;
  final void Function(String) onSelect;
  @override
  Widget build(BuildContext context) {
    return Row(
        children: titles
            .map((title) => TabTitle(
                  title: title,
                  isActive: title == activeTab,
                  onSelect: (String title) => onSelect(title),
                ))
            .toList());
  }
}
