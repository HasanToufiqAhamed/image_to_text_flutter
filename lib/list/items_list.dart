import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_to_text/a_main_pages/final_output.dart';
import 'package:image_to_text/model/item_details.dart';
import 'package:intl/intl.dart';

Widget itemsList({
  required ItemDetails item,
  required BuildContext context,
}) {
  DateFormat dateThisYear = new DateFormat('d MMM yyyy, hh:mm a');
  DateFormat dateThisMonth = new DateFormat('d MMM, hh:mm a');
  DateFormat dateToday = new DateFormat('hh:mm a');
  DateTime todayDate = DateTime.now();

  return ListTile(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FinalOutput(
            itemDetails: item,
          ),
        ),
      );
    },
    title: Text(
      '${item.text}',
      maxLines: 2,
    ),
    leading: Container(
      width: 80,
      height: 1000,
      color: Colors.black12,
      child: Image.file(
        File(
          item.image!,
        ),
      ),
    ),
    subtitle: Text(
      item.createdAt!.day == todayDate.day &&
              item.createdAt!.month == todayDate.month &&
              item.createdAt!.year == todayDate.year
          ? '${dateToday.format(item.createdAt!)}'
          : item.createdAt!.day != todayDate.day &&
                  item.createdAt!.month == todayDate.month &&
                  item.createdAt!.year == todayDate.year
              ? '${dateThisMonth.format(item.createdAt!)}'
              : '${dateThisYear.format(item.createdAt!)}',
      style: TextStyle(
        fontSize: 12,
      ),
    ),
  );
}
