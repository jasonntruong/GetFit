import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription>? cameras;

  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController controller;
  bool _isLoaded = false;

  @override
  void initState() {
    loadCameras();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void loadCameras() async {
    if (widget.cameras == null) return;
    controller = CameraController(widget.cameras![0], ResolutionPreset.max);

    controller.initialize().then((_) {
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
    Size mediaSize = MediaQuery.of(context).size;
    return (_isLoaded && controller.value.isInitialized)
        ? CameraPreview(controller)
        : const SizedBox.shrink();
  }
}
