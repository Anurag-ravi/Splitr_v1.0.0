// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pay.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PayAdapter extends TypeAdapter<Pay> {
  @override
  final int typeId = 2;

  @override
  Pay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pay(
      uuid: fields[0] as String,
      expenseid: fields[1] as String,
      isBy: fields[2] as bool,
      amount: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Pay obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.uuid)
      ..writeByte(1)
      ..write(obj.expenseid)
      ..writeByte(2)
      ..write(obj.isBy)
      ..writeByte(3)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
