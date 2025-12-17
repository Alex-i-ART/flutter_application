// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayDataAdapter extends TypeAdapter<DayData> {
  @override
  final int typeId = 1;

  @override
  DayData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayData(
      date: fields[0] as DateTime,
      city: fields[1] as String,
      sunrise: fields[2] as DateTime,
      sunset: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DayData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.city)
      ..writeByte(2)
      ..write(obj.sunrise)
      ..writeByte(3)
      ..write(obj.sunset)
      ..writeByte(4)
      ..write(obj.dayLength);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
