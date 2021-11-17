import 'package:hive/hive.dart';
import 'package:image_to_text/model/item_details.dart';

class Boxes {
  static Box<ItemDetails> getItems() =>
      Hive.box<ItemDetails>('items');
}