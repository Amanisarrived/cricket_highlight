// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveMovieModelAdapter extends TypeAdapter<HiveMovieModel> {
  @override
  final int typeId = 0;

  @override
  HiveMovieModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveMovieModel(
      id: fields[0] as int,
      name: fields[1] as String,
      url: fields[2] as String,
      isTrending: fields[3] as bool,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveMovieModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.isTrending)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveMovieModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
