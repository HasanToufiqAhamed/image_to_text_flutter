import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_to_text/a_main_pages/final_output.dart';
import 'package:image_to_text/main.dart';

enum ScreenMode { liveFeed, gallery }

class CameraPage extends StatefulWidget {
  CameraPage();

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  int _cameraIndex = 0;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  late CameraController _controller;


  @override
  void initState() {
    super.initState();

    _startLiveFeed();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _liveFeedBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          try {
            XFile image = await _controller.takePicture();
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FinalOutput(
                  filePath: image.path,
                ),
              ),
            );

          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller.getMinZoomLevel().then((value) {
        zoomLevel = value;
        minZoomLevel = value;
      });
      _controller.getMaxZoomLevel().then((value) {
        maxZoomLevel = value;
      });
    });
  }

  Widget _liveFeedBody() {
    if (_controller.value.isInitialized == false) {
      return Container(
        child: Text('g'),
      );
    }
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          CameraPreview(_controller),
        ],
      ),
    );
  }

  Future _stopLiveFeed() async {
    await _controller.stopImageStream();
    await _controller.dispose();
  }
}
