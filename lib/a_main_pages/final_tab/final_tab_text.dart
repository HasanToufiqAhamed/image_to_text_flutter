import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FinalTabText extends StatefulWidget {
  String text;

  FinalTabText({required this.text});

  @override
  _FinalTabTextState createState() => _FinalTabTextState();
}

class _FinalTabTextState extends State<FinalTabText> {
  TextEditingController textField = new TextEditingController();

  @override
  void initState() {
    super.initState();

    textField.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.file_copy),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: '${textField.text}'));
          Fluttertoast.showToast(msg: 'Text copy tou your clipboard');
        },
      ),
      body: Container(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          bottom: 15,
        ),
        child: TextFormField(
          controller: textField,
          cursorColor: Colors.black,
          keyboardType: TextInputType.text,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
