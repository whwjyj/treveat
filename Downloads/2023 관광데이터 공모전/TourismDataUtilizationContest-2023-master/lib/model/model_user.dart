import 'package:json_annotation/json_annotation.dart';

part 'model_user.g.dart';

@JsonSerializable()
class model_user {
  final String no;
  final String name;
  final String token_key;
  final String infotext;
  final String profileimg;
  final String allergy;
  final String tour;
  final String email;

  model_user(
      this.no,
      this.name,
      this.token_key,
      this.infotext,
      this.profileimg,
      this.allergy,
      this.tour,
      this.email
      );

  factory model_user.fromJson(Map<String, dynamic> json) => _$model_reviewFromJson(json);

  Map<String, dynamic> toJson() => _$model_reviewToJson(this);
}
