// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PayModelAdapter extends TypeAdapter<PayModel> {
  @override
  final int typeId = 9;

  @override
  PayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PayModel(
      username: fields[0] as String,
      totalOrder: fields[1] as String?,
      timeOrder: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PayModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.totalOrder)
      ..writeByte(2)
      ..write(obj.timeOrder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
