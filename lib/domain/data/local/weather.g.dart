// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../model/weather.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherAdapter extends TypeAdapter<Weather> {
  @override
  final int typeId = 0;

  @override
  Weather read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Weather(
      cityId: fields[0] as int,
      cityName: fields[1] as String,
      country: fields[2] as String,
      temperature: fields[3] as int,
      description: fields[4] as String,
      sunrise: fields[5] as String,
      sunset: fields[6] as String,
      forecast: (fields[7] as List).cast<Forecast>(),
      date: fields[8] as DateTime,
      icon: fields[9] as String,
      humidity: fields[10] as dynamic,
      wind: fields[11] as dynamic,
      pressure: fields[12] as int,
      timeZone: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Weather obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.cityId)
      ..writeByte(1)
      ..write(obj.cityName)
      ..writeByte(2)
      ..write(obj.country)
      ..writeByte(3)
      ..write(obj.temperature)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.sunrise)
      ..writeByte(6)
      ..write(obj.sunset)
      ..writeByte(7)
      ..write(obj.forecast)
      ..writeByte(8)
      ..write(obj.date)
      ..writeByte(9)
      ..write(obj.icon)
      ..writeByte(10)
      ..write(obj.humidity)
      ..writeByte(11)
      ..write(obj.wind)
      ..writeByte(12)
      ..write(obj.pressure)
      ..writeByte(13)
      ..write(obj.timeZone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
