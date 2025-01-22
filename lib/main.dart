import 'package:flutter/material.dart';
import 'package:flutter_app/Mypage/customer_center.dart';
import 'package:flutter_app/Mypage/language.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Firstview.dart';
import 'package:flutter_app/tab/map.dart';
import 'package:flutter_app/tab/list.dart';
import 'package:flutter_app/tab/friend.dart';
import 'package:flutter_app/tab/mypage.dart';
import 'package:flutter_app/Mypage/profile_update.dart';
import 'Firstview_token.dart';
import 'Mypage/allergy_choice.dart';
import 'Mypage/tour_choice.dart';
import 'Mypage/like_board.dart';

void main() async {
  KakaoSdk.init(nativeAppKey: 'c2d639ef25b9728ebf587f4578467801');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      routes: {
        '/first':(context)=> Firstview(),
        '/first_token':(context)=> Firstview_token(),
        '/map':(context)=> MapScreen(),
        '/list':(context)=> ImageDisplay(),
        '/friend':(context)=> Friend(),
        '/mypage':(context)=> MyPage(),
        '/customer_center':(context) => Customer_center(),
        '/language':(context)=> Language(),
        '/profile_update':(context)=> Profile_update(),
        '/like_board':(context)=> Like_board(),
        '/tour_choice':(context)=> Tour_choice(),
        '/allergy_choice':(context)=> Allergy_choice()
      },
      home: Firstview(),
    );
  }
}

