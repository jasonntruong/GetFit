/// Object detection helper functions

import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

final DUMBBELL = "Dumbbell";
final CONFIDENCE_THRESHOLD = 0.7;

/// Load the model
loadModel() async {
  await Tflite.loadModel(
      model: "assets/model.tflite", labels: "assets/labels.txt");
}

/// Runs model on image from imgCamera and returns the recognitions the model sees
runModel(CameraImage imgCamera) async {
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

  return recognitions;
}

/// Gets the model's confidence in a dumbbell being in the image
double getDumbbellConfidence(recognitions) {
  for (var recognition in recognitions!) {
    if (recognition["label"] == DUMBBELL) {
      return recognition["confidence"];
    }
  }
  return 0.0;
}
