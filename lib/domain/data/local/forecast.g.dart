// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../model/forecast.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ForecastAdapter extends TypeAdapter<Forecast> {
  @override
  final int typeId = 1;

  @override
  Forecast read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Forecast(
      date: fields[0] as String,
      temperature: fields[1] as int,
      description: fields[2] as String,
      icon: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Forecast obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.temperature)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ForecastAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
