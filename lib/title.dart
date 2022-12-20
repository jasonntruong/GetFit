import 'package:flutter/cupertino.dart';

class TopTitle extends StatelessWidget {
  const TopTitle({Key? key, required this.name}) : super(key: key);
  final String name;
  @override
  Widget build(BuildContext context) {
    return Text(name,
        style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold));
  }
}
