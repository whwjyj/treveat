import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app/kakao/social_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class loginViewModel {
  final SocialLogin _socialLogin;
  bool isLogined = false;
  User? user;

  loginViewModel(this._socialLogin);

  Future login(BuildContext context) async {
    isLogined = await _socialLogin.login(context);
    if(isLogined) {
      user = await UserApi.instance.me();
    }
  }

  Future logout(BuildContext context) async {
    await _socialLogin.logout(context);
    isLogined = false;
    user = null;
  }
}