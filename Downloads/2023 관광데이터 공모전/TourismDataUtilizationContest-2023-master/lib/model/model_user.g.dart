// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

model_user _$model_reviewFromJson(Map<String, dynamic> json) => model_user(

  json['no'] as String,
  json['name'] as String,
  json['token_key'] as String,
  json['infotext'] as String,
  json['profileimg'] as String,
  json['allergy'] as String,
  json['tour'] as String,
  json['email'] as String,
);

Map<String, dynamic> _$model_reviewToJson(model_user instance) =>
    <String, dynamic>{
      'no': instance.no,
      'name': instance.name,
      'token_key': instance.token_key,
      'infotext': instance.infotext,
      'profileimg': instance.profileimg,
      'allergy': instance.allergy,
      'keyword': instance.tour,
      'email': instance.email
    };
