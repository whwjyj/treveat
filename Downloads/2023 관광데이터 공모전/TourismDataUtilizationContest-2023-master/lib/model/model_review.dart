import 'package:json_annotation/json_annotation.dart';

part 'model_review.g.dart';

@JsonSerializable()
class model_review {
  final String no;
  final String loc_code;
  final String token_key;
  final String rating;
  final String author;
  final String regdate;
  final String content;
  // @JsonKey(defaultValue: 'null')
  final String imglink;
  // @JsonKey(defaultValue: 'null')
  final String imglink2;

  model_review(
      this.no,
      this.loc_code,
      this.token_key,
      this.rating,
      this.author,
      this.regdate,
      this.content,
      this.imglink,
      this.imglink2,
      );

  factory model_review.fromJson(Map<String, dynamic> json) => _$model_reviewFromJson(json);

  Map<String, dynamic> toJson() => _$model_reviewToJson(this);
}
