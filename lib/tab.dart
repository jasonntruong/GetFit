import 'package:flutter/cupertino.dart';

class TabTitle extends StatelessWidget {
  const TabTitle(
      {Key? key,
      required this.title,
      required this.isActive,
      required this.onSelect})
      : super(key: key);
  final String title;
  final bool isActive;
  final void Function(String) onSelect;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => {onSelect(title)},
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: isActive
            ? Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            : Text(
                title,
                style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffaaaaaa)),
              ),
      ),
    );
  }
}

class SelectionTabs extends StatelessWidget {
  const SelectionTabs(
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
