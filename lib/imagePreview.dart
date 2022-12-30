import 'dart:io';

import 'package:flutter/cupertino.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({Key? key, required this.imagePath}) : super(key: key);
  final String imagePath;
  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Image.file(File(widget.imagePath), width: 100),
    );
  }
}
