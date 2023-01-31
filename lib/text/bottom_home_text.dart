/// Bottom home text widget

import 'package:flutter/cupertino.dart';

class BottomHomeText extends StatefulWidget {
  const BottomHomeText({Key? key, required this.isSkipped}) : super(key: key);

  final bool isSkipped;
  @override
  State<BottomHomeText> createState() => _BottomHomeTextState();
}

class _BottomHomeTextState extends State<BottomHomeText> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Image.asset('assets/muscle.png', height: 150, width: 150),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
                widget.isSkipped
                    ? "Try again tomorrow!"
                    : "Keep up the great work!",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
