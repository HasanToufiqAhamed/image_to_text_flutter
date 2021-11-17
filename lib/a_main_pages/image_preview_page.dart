import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_to_text/a_main_pages/final_output.dart';
import 'package:image_to_text/main.dart';

class ImagePreviewPage extends StatefulWidget {
  String imagePath;

  ImagePreviewPage({required this.imagePath});

  @override
  _ImagePreviewPageState createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  String? imagePath;

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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => FinalOutput(
                            filePath: imagePath!,
                          ),
                        ),
                      );
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
                      child: Icon(
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
