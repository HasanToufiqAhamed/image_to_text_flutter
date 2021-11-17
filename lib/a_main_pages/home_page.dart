import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_text/a_main_pages/image_preview_page.dart';
import 'package:image_to_text/box/boxes.dart';
import 'package:image_to_text/model/item_details.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'final_output.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ImagePicker? _imagePicker;

  final dateFormat = new DateFormat('d MMM yy, hh:mm a');

  @override
  void dispose() {
    Hive.box('items').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            child: Icon(Icons.image),
            onPressed: () {
              _getImage(ImageSource.gallery);
            },
          ),
          SizedBox(width: 15,),
          FloatingActionButton(
            child: Icon(Icons.camera),
            onPressed: () {
              _getImage(ImageSource.camera);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ValueListenableBuilder<Box<ItemDetails>>(
          valueListenable: Boxes.getItems().listenable(),
          builder: (context, box, _) {
            List<ItemDetails> itemDetails = box.values.toList().cast<ItemDetails>().reversed.toList();

            return makeList(itemDetails);
          },
        ),
      ),
    );
  }

  makeList(List<ItemDetails> item) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: item.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FinalOutput(
                itemDetails: item[index],
              ),
            ),
          );
        },
        title: Text(
          '${item[index].text}',
          maxLines: 2,
        ),
        leading: Container(
          width: 80,
          height: 1000,
          color: Colors.black12,
          child: Image.file(
            File(
              item[index].image!,
            ),
          ),
        ),
        subtitle: Text(
          '${dateFormat.format(item[index].createdAt!)}',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget buildContent(List<ItemDetails> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          'No expenses yet!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          SizedBox(height: 24),
          Text(
            'Net Expense: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              shrinkWrap: false,
              padding: EdgeInsets.all(8),
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                final transaction = transactions[index];

                return buildTransaction(context, transaction);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildTransaction(
    BuildContext context,
    ItemDetails transaction,
  ) {

    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          transaction.text!,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(transaction.image!),
      ),
    );
  }

  Future _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ImagePreviewPage(
            imagePath: pickedFile.path,
          ),
        ),
      );
    } else {
      print('No image selected.');
    }
  }

  Future addItemDetails(String image, String text) async {
    final itemDetails = ItemDetails()
      ..image = image
      ..text = text
      ..createdAt = DateTime.now();

    final box = Boxes.getItems();
    box.add(itemDetails);
  }
}
