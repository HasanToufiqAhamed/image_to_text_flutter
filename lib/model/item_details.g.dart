// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemDetailsAdapter extends TypeAdapter<ItemDetails> {
  @override
  final int typeId = 0;

  @override
  ItemDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemDetails()
      ..image = fields[0] as String?
      ..text = fields[1] as String?
      ..createdAt = fields[2] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, ItemDetails obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
