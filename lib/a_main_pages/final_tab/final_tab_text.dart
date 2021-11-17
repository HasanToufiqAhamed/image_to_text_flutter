import 'package:flutter/material.dart';

class FinalTabText extends StatefulWidget {
  String imagePath;

  FinalTabText({required this.imagePath});

  @override
  _FinalTabTextState createState() => _FinalTabTextState();
}

class _FinalTabTextState extends State<FinalTabText> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
                child: SelectableText(widget.imagePath),
              ),
      ),
    );
  }
}
