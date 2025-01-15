// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

model_review _$model_reviewFromJson(Map<String, dynamic> json) => model_review(
      json['no'] as String,
      json['loc_code'] as String,
      json['token_key'] as String,
      json['rating'] as String,
      json['author'] as String,
      json['regdate'] as String,
      json['content'] as String,
      json['imglink'] as String,
      json['imglink2'] as String,
    );

Map<String, dynamic> _$model_reviewToJson(model_review instance) =>
    <String, dynamic>{
      'no': instance.no,
      'loc_code': instance.loc_code,
      'token_key': instance.token_key,
      'rating': instance.rating,
      'author': instance.author,
      'regdate': instance.regdate,
      'content': instance.content,
      'imglink': instance.imglink,
      'imglink2': instance.imglink2,
    };
