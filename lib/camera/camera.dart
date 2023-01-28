/// Camera Widget to take pictures

import 'package:flutter/foundation.dart';
import 'package:get_fit/alerts/alert.dart';
import 'package:get_fit/helper/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:get_fit/home.dart';
import 'package:get_fit/camera/object_detection.dart';
import 'package:tflite/tflite.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
    required this.cameras,
  }) : super(key: key);
  // list of cameras on the device
  final List<CameraDescription>? cameras;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController _controller;
  late CameraImage _img;

  List<dynamic>? _recognitions;

  bool _isCameraLoaded = false;
  bool _isCameraBusy = false;

  String _imagePath = "";

  /// Loads and readies camera
  void loadCamera() async {
    if (widget.cameras == null) return;
    _controller = CameraController(widget.cameras![0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isCameraLoaded = true;
        // Start image stream and store frames in _img
        _controller.startImageStream((imageFromStream) => {
              if (!_isCameraBusy)
                {
                  _isCameraBusy = true,
                  _img = imageFromStream,
                  // runModelOnStreamFrames(),
                }
            });
      });
    }).catchError((Object e) {
      if (e is CameraException && kDebugMode) {
        print('CAMERA EXCEPTION: $e');
      }
      return;
    });
  }

  /// When image taken, scan the image for a dumbbell
  void onImageTaken() async {
    try {
      XFile _lastFrame = await _controller.takePicture();
      _controller.pausePreview();
      // Run object detection model over image
      _recognitions = await runModel(_img);
      setState(() {
        _isCameraBusy = false;
      });

      // Get confidence of dumbbell in image
      double _dumbbellConfidence = getDumbbellConfidence(_recognitions);

      if (_dumbbellConfidence >= CONFIDENCE_THRESHOLD) {
        setState(() {
          _imagePath = _lastFrame.path;
        });
        saveLastUpdated();
        _controller.dispose();
      } else {
        // Alert user if no dumbbell found
        showAlert1Action(context, "Try again", "\nWe could not find a dumbbell",
            "Ok", () => {_controller.resumePreview()});
      }
      if (!mounted) return;
    } catch (e) {}
  }

  @override
  void initState() {
    loadCamera();
    loadModel();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    _controller.dispose();
    await Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (_imagePath != '') {
      saveToStorage('imagePath', _imagePath);
      return Home(imagePath: _imagePath);
    }
    return (_isCameraLoaded && _controller.value.isInitialized)
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
                      onImageTaken();
                    },
                  ),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
