// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

model_friend _$model_friendFromJson(Map<String, dynamic> json) => model_friend(
      json['no'] as String,
      json['token_key'] as String,
      json['email'] as String,
      json['name'] as String,
      json['infotext'] as String,
      json['profileimg'] as String,
      json['allergy'] as String,
      json['tour'] as String,
    );

Map<String, dynamic> _$model_friendToJson(model_friend instance) =>
    <String, dynamic>{
      'no': instance.no,
      'token_key': instance.token_key,
      'email': instance.email,
      'name': instance.name,
      'infotext': instance.infotext,
      'profileimg': instance.profileimg,
      'allergy': instance.allergy,
      'tour': instance.tour,
    };
