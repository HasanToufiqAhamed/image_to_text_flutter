import 'dart:io';

import 'package:flutter/material.dart';

class FinalTabImage extends StatefulWidget {
  String imagePath;
  FinalTabImage({required this.imagePath});

  @override
  _FinalTabImageState createState() => _FinalTabImageState();
}

class _FinalTabImageState extends State<FinalTabImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.file(
        File(widget.imagePath),
      ),
    );
  }
}
