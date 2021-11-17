import 'package:hive/hive.dart';

part 'item_details.g.dart';

@HiveType(typeId: 0)

class ItemDetails extends HiveObject {

  @HiveField(0)
  late String? image;

  @HiveField(1)
  late String? text;

  @HiveField(2)
  late DateTime? createdAt;
}
