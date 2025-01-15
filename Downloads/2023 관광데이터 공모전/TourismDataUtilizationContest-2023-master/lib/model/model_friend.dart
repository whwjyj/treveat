import 'package:json_annotation/json_annotation.dart';

part 'model_friend.g.dart';

@JsonSerializable()
class model_friend {
  final String no;
  final String token_key;
  final String email;
  final String name;
  final String infotext;
  final String profileimg;
  final String allergy;
  final String tour;

  model_friend(
      this.no,
      this.token_key,
      this.email,
      this.name,
      this.infotext,
      this.profileimg,
      this.allergy,
      this.tour,
      );

  factory model_friend.fromJson(Map<String, dynamic> json) =>
      _$model_friendFromJson(json);

  Map<String, dynamic> toJson() => _$model_friendToJson(this);
}
