import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_to_text/widget/text_detector_painter.dart';

class FinalTabText extends StatefulWidget {
  String imagePath;

  FinalTabText({required this.imagePath});

  @override
  _FinalTabTextState createState() => _FinalTabTextState();
}

class _FinalTabTextState extends State<FinalTabText> {
  TextDetectorV2 textDetector = GoogleMlKit.vision.textDetectorV2();
  CustomPaint? customPaint;
  String? _fullText;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _processPickedFile(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Text(_fullText!),
            ),
    );
  }

  Future _processPickedFile(String pickedFile) async {
    final inputImage = InputImage.fromFilePath(pickedFile);
    processImage(inputImage);
  }

  Future<void> processImage(InputImage inputImage) async {
    final recognisedText = await textDetector.processImage(inputImage,
        script: TextRecognitionOptions.DEVANAGIRI);
    print('Found ${recognisedText.blocks.length} textBlocks');
    print(recognisedText.text);
    setState(() {
      loading = false;
      _fullText = recognisedText.text;
    });
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = TextDetectorPainter(
          recognisedText,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    if (mounted) {
      setState(() {});
    }
  }
}
