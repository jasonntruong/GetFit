import 'package:flutter/cupertino.dart';

class TextInput extends StatefulWidget {
  const TextInput({Key? key, required this.placeholder}) : super(key: key);
  final String placeholder;
  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  late TextEditingController _textController;
  bool _textControllerLoaded = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();

    setState(() {
      _textControllerLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _textControllerLoaded
        ? CupertinoTextField.borderless(
            controller: _textController,
            textAlign: TextAlign.center,
            placeholder: widget.placeholder,
            placeholderStyle: TextStyle(color: CupertinoColors.inactiveGray),
            onEditingComplete: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onSubmitted: (word) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
          )
        : const SizedBox.shrink();
  }
}
