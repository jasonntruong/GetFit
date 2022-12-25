import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:get_fit/friends.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController _controller;
  bool _isLoaded = false;
  String _imagePath = "";

  @override
  void initState() {
    loadCameras();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void loadCameras() async {
    if (widget.cameras == null) return;
    _controller = CameraController(widget.cameras[0], ResolutionPreset.max);

    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isLoaded = true;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        print('CAMERA EXCEPTION: ');
        print(e);
      }
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (_imagePath != '') return Friends(imagePath: _imagePath);
    return (_isLoaded && _controller.value.isInitialized)
        ? Stack(
            children: [
              CameraPreview(_controller),
              SizedBox(
                height: height - 160,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CupertinoButton(
                    child: const Icon(
                      CupertinoIcons.circle,
                      size: 80,
                    ),
                    onPressed: () async {
                      try {
                        final image = await _controller.takePicture();
                        setState(() {
                          _imagePath = image.path;
                        });
                        if (!mounted) return;
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}

class DisplayImage extends StatelessWidget {
  const DisplayImage({Key? key, required this.imagePath}) : super(key: key);
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      child: Image.file(File(imagePath)),
    );
  }
}
