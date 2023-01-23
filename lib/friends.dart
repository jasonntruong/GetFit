import 'package:flutter/cupertino.dart';
import 'package:get_fit/textinput.dart';

import 'imagePreview.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key, required this.imagePath, required this.foundObjects})
      : super(key: key);
  final String imagePath;
  final String foundObjects;
  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      ImagePreview(imagePath: widget.imagePath),
      const TextInput(
        placeholder: "Add a caption...",
      ),
      const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Text(
          "Add friends to see their activity!",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Text("DEBUG: " + widget.foundObjects),
      ),
    ]);
  }
}
