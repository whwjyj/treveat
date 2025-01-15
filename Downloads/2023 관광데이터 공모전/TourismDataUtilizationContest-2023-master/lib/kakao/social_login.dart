import 'package:flutter/cupertino.dart';

abstract class SocialLogin {
  Future login(BuildContext context);
  Future logout(BuildContext context);
}