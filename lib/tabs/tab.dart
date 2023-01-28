/// Tab title widget

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
            ? // If tab is active, be white
            Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            : // If tab is inactive, be gray
            Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xffaaaaaa)),
              ),
      ),
    );
  }
}
