import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_to_text/a_main_pages/final_output.dart';
import 'package:image_to_text/main.dart';
import 'package:image_to_text/widget/text_detector_painter.dart';
import 'package:hive/hive.dart';
import 'package:image_to_text/box/boxes.dart';
import 'package:image_to_text/model/item_details.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ImagePreviewPage extends StatefulWidget {
  String imagePath;

  ImagePreviewPage({required this.imagePath});

  @override
  _ImagePreviewPageState createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  String? imagePath;
  TextDetectorV2 textDetector = GoogleMlKit.vision.textDetectorV2();
  CustomPaint? customPaint;
  String? _fullText;
  bool loading = false;

  @override
  void initState() {
    setState(() {
      imagePath = widget.imagePath;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => setState(() {
              imagePath = widget.imagePath;
            }),
            icon: Icon(Icons.rotate_right),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              color: Colors.black,
              child: Image.file(
                File(imagePath!),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: defAppBar.preferredSize.height + 10,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(Icons.crop),
                  onPressed: () => _cropImage(
                    imagePath!,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        loading = true;
                        _processPickedFile(imagePath!);
                      });
                    },
                    child: Container(
                      height: double.maxFinite,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4), // Shadow position
                          ),
                        ],
                      ),
                      child: loading
                          ? Container(
                        alignment: Alignment.center,
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1,
                              ),
                            )
                          : Icon(
                              Icons.arrow_right_alt,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
              ],
            ),
          )
        ],
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
      _fullText = recognisedText.text;
      addItemDetails(
        imagePath!,
        _fullText!,
      );
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

  Future addItemDetails(String image, String text) async {
    final itemDetails = ItemDetails()
      ..image = image
      ..text = text
      ..createdAt = DateTime.now();

    final box = Boxes.getItems();
    box.add(itemDetails);

    setState(() {
      loading = false;
    });
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FinalOutput(
          itemDetails: itemDetails,
        ),
      ),
    );
  }

  Future<Null> _cropImage(String path) async {
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: path,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop image',
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        cropFrameStrokeWidth: 5,
        backgroundColor: Colors.black,
        statusBarColor: Colors.black,
        lockAspectRatio: false,
        showCropGrid: false,
        hideBottomControls: true,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Crop image',
        hidesNavigationBar: true,
      ),
    );
    if (croppedFile != null) {
      setState(() {
        imagePath = croppedFile.path;
      });
    }
  }
}
