import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_text/a_main_pages/image_preview_page.dart';
import 'package:image_to_text/box/boxes.dart';
import 'package:image_to_text/model/item_details.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ImagePicker? _imagePicker;

  @override
  void dispose() {
    Hive.box('items').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () {
          // _getImage(ImageSource.camera);
          addItemDetails(
              '/data/user/0/hta.app.imagetotext.image_to_text/cache/image_cropper_1637132367494.jpg',
              'hello text save');
        },
      ),
      body: Column(
        children: [
          Container(
            child: TextButton(
              child: Text('hello'),
              onPressed: () => _getImage(ImageSource.gallery),
            ),
          ),
          ValueListenableBuilder<Box<ItemDetails>>(
            valueListenable: Boxes.getItems().listenable(),
            builder: (context, box, _) {
              final itemDetails = box.values.toList().cast<ItemDetails>();

              return makeList(itemDetails);
            },
          ),
        ],
      ),
    );
  }

  makeList(List<ItemDetails> item) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: item.length,
      itemBuilder: (context, index) => ListTile(
        title: Text('${item[index].text}'),
        leading: Container(
          height: 80,
          width: 100,
          child: Image.file(
            File(item[index].image!),
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
    /*final color = transaction.isExpense ? Colors.red : Colors.green;
    final date = DateFormat.yMMMd().format(transaction.createdDate);
    final amount = '\$' + transaction.amount.toStringAsFixed(2);*/

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
