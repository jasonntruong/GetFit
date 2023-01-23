import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:get_fit/friends.dart';
import 'package:tflite/tflite.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key, required this.cameras, required this.modelPath})
      : super(key: key);
  final List<CameraDescription> cameras;
  final String modelPath;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController _controller;
  bool _isLoaded = false;
  String _imagePath = "";
  String _foundObjects = "";

  @override
  void initState() {
    loadCameras();
    super.initState();
    loadModel();
  }

  @override
  void dispose() async {
    super.dispose();
    _controller.dispose();
    await Tflite.close();
  }

  bool isWorking = false;
  late CameraImage imgCamera;
  void loadCameras() async {
    if (widget.cameras == null) return;
    _controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isLoaded = true;
        _controller.startImageStream((imageFromStream) => {
              if (!isWorking)
                {
                  isWorking = true,
                  imgCamera = imageFromStream,
                  runModelOnStreamFrames(),
                }
            });
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        print('CAMERA EXCEPTION: ');
        print(e);
      }
      return;
    });
  }

  runModelOnStreamFrames() async {
    var recognitions = await Tflite.runModelOnFrame(
      bytesList: imgCamera.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: imgCamera.height,
      imageWidth: imgCamera.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 10,
      threshold: 0.1,
      asynch: true,
    );

    _foundObjects = "";

    recognitions!.forEach((response) {
      _foundObjects += response["label"] +
          " " +
          (response["confidence"] as double).toStringAsFixed(2) +
          "\n\n";
    });
    setState(() {
      _foundObjects;
    });

    isWorking = false;
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt");
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (_imagePath != '') {
      return Friends(imagePath: _imagePath, foundObjects: _foundObjects);
    }
    return (_isLoaded && _controller.value.isInitialized)
        ? Stack(
            children: [
              CameraPreview(_controller),
              SizedBox(
                height: height - 200,
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
                        _controller.dispose();
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
