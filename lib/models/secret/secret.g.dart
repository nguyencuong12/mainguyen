// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secret.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SecretModelAdapter extends TypeAdapter<SecretModel> {
  @override
  final int typeId = 10;

  @override
  SecretModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SecretModel(
      password: fields[0] as String,
      facebooks: (fields[1] as List?)?.cast<FacebookSecret>(),
      zalos: (fields[2] as List?)?.cast<ZaloSecret>(),
      emails: (fields[3] as List?)?.cast<EmailSecret>(),
    );
  }

  @override
  void write(BinaryWriter writer, SecretModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.password)
      ..writeByte(1)
      ..write(obj.facebooks)
      ..writeByte(2)
      ..write(obj.zalos)
      ..writeByte(3)
      ..write(obj.emails);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecretModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FacebookSecretAdapter extends TypeAdapter<FacebookSecret> {
  @override
  final int typeId = 11;

  @override
  FacebookSecret read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FacebookSecret(
      password: fields[1] as String?,
      username: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FacebookSecret obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FacebookSecretAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ZaloSecretAdapter extends TypeAdapter<ZaloSecret> {
  @override
  final int typeId = 12;

  @override
  ZaloSecret read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ZaloSecret(
      password: fields[1] as String,
      username: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ZaloSecret obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZaloSecretAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmailSecretAdapter extends TypeAdapter<EmailSecret> {
  @override
  final int typeId = 13;

  @override
  EmailSecret read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmailSecret(
      password: fields[1] as String,
      username: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EmailSecret obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailSecretAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
