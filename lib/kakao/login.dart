import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import '../model/model_user.dart';
import 'social_login.dart';
import 'package:http/http.dart' as http;
import 'user_kakao_info.dart' as info;

Future<List<model_user>> Userinfo(String token_key) async {
  final response = await http.get(Uri.parse(
      'http://dongseok1.dothome.co.kr/treveat/mUsers/selectUsers.php?token_key=$token_key'));

  if (response.statusCode == 200) {
    var responseBody = utf8.decode(response.bodyBytes);
    final json = "${responseBody}";
    print(json);
    List list = await (jsonDecode(json) as List<dynamic>);
    return list.map<model_user>((map) => model_user.fromJson(map)).toList();

  }
  else {
    throw Exception('Not Found');
  }
}

//신규유저 정보 Post
Future<String> call(String name, String token_key, String infotext, String profileimg, String allergy,
    String tour, String email) async {
  Map<String, String> headers = { "Accesstoken": "access_token"};

  var url = Uri.parse('http://dongseok1.dothome.co.kr/treveat/mUsers/insertPage.php');

  http.MultipartRequest request = new http.MultipartRequest("POST", url);
  request.headers.addAll(headers);

  request.fields['name'] = name;
  request.fields['token_key'] = token_key;
  request.fields['infotext'] = infotext;
  request.fields['profileimg'] = profileimg;
  request.fields['allergy'] = allergy;
  request.fields['tour'] = tour;
  request.fields['email'] = email;

  var response = await request.send();

  final responsebody = await response.stream.bytesToString(); //response -> string으로 변환

  print(responsebody);

  if (response.statusCode == 200) {
    return '작성이 완료되었습니다.';
  }
  else {
    return '작성에 실패하였습니다.';
  }
}

class KakaoLogin implements SocialLogin {
  @override
  Future login(BuildContext context) async {
    try {
      bool isInstalled = await isKakaoTalkInstalled(); // 카톡 설치 여부
      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      if(isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoTalk();
          print('카카오어플로 구동');

          final url = Uri.https('kapi.kakao.com', '/v2/user/me');

          final response = await http.get(
            url,
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
            },
          );

          TokenManagerProvider.instance.manager.setToken(token);

          User user = await UserApi.instance.me();

          var getNo = await Userinfo(user.id.toString());

          if(getNo[0].token_key == null) {
            info.token_key = user.id.toString();
            info.name = user.kakaoAccount!.profile!.nickname!;
            info.profileimg = user.kakaoAccount!.profile!.profileImageUrl!;
            info.infotext = '한 줄 소개를 작성해주세요.';
            info.email = user.kakaoAccount!.email!;

            String name = user.kakaoAccount!.profile!.nickname!;
            String token_key = info.token_key;
            String profileimg = user.kakaoAccount!.profile!.profileImageUrl!;
            String email = user.kakaoAccount!.email!;

            await call(name, token_key, '', profileimg, '', '', email);
          }
          else {
            info.no = getNo[0].no.toString();
            info.token_key = getNo[0].token_key;
            info.name = getNo[0].name;
            info.profileimg = getNo[0].profileimg;
            info.infotext = getNo[0].infotext;
            info.email = getNo[0].email;

            final List<String> allergy = getNo[0].allergy.split(', ');
            info.allergy = allergy;

            final List<String> keyword = getNo[0].tour.split(', ');
            info.keyword = keyword;
          }

          Navigator.pushNamed(context, '/first_token');

        }
        catch(error) {
          print(error);
        }
      }
      else {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 구동');

          final url = Uri.https('kapi.kakao.com', '/v2/user/me');

          final response = await http.get(
            url,
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
            },
          );

          TokenManagerProvider.instance.manager.setToken(token);

          User user = await UserApi.instance.me();

          var getNo = await Userinfo(user.id.toString());

          if(getNo[0].token_key == '') {
            info.token_key = user.id.toString();
            info.name = user.kakaoAccount!.profile!.nickname!;
            info.profileimg = user.kakaoAccount!.profile!.profileImageUrl!;
            info.infotext = '한 줄 소개를 작성해주세요.';
            info.email = user.kakaoAccount!.email!;

            String name = user.kakaoAccount!.profile!.nickname!;
            String token_key = info.token_key;
            String profileimg = user.kakaoAccount!.profile!.profileImageUrl!;
            String email = user.kakaoAccount!.email!;

            await call(name, token_key, '', profileimg, '', '', email);
          }
          else {
            info.no = getNo[0].no.toString();
            info.token_key = getNo[0].token_key;
            info.name = getNo[0].name;
            info.profileimg = getNo[0].profileimg;
            info.infotext = getNo[0].infotext;
            info.email = getNo[0].email;

            if(getNo[0].allergy != '') {
              final List<String> allergy = getNo[0].allergy.split(', ');
              info.allergy = allergy;
            }
            if(getNo[0].allergy != '') {
              final List<String> keyword = getNo[0].tour.split(', ');
              info.keyword = keyword;
            }
          }

          Navigator.pushNamed(context, '/first_token');
        }
        catch(error) {
          print(error);
        }
      }
    }
    catch(error) {
      print(error);
    }
  }
  @override
  Future logout(BuildContext context) async {
    try {
      info.token_key = '';
      await UserApi.instance.unlink();
      Navigator.pushNamed(context, '/first');
    }
    catch(error) {
    }
  }
}