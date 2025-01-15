import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/kakao/login.dart';
import '../Mypage/profile_update.dart';
import '../kakao/login_view_model.dart';
import 'package:flutter_app/kakao/user_kakao_info.dart' as info;
import 'package:http/http.dart' as http;
import '../model/model_user.dart';

Future<List<model_user>> Userinfo(String token_key) async {
  final response = await http.get(Uri.parse(
      'http://dongseok1.dothome.co.kr/treveat/mUsers/selectUsers.php?token_key=$token_key'));

  if (response.statusCode == 200) {
    var responseBody = utf8.decode(response.bodyBytes);
    final json = "${responseBody}"; //responseBody는 {키:값},{키:값}형태
    print(json);
    List list = await (jsonDecode(json) as List<dynamic>);
    return list.map<model_user>((map) => model_user.fromJson(map)).toList();

  }
  else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Not Found');
  }
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State {
  final viewModel = loginViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Treveat', style: TextStyle(color: Color(0xff69E2E3))),
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height:1.0,
                  width: MediaQuery.of(context).size.width,
                  color:Color(0xffe5e5e5)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: [
                      Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20, left: 20),
                              child:
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(info.profileimg),
                              ),
                            )
                          ]
                      ),
                      Column(//vm
                          children: [
                            Row(
                                children: [
                                  Container(
                                      width: 245,
                                      height: 25,
                                      margin: EdgeInsets.only(top: 28, left: 15),
                                      child:
                                      Text("${info.name}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                  )
                                ]
                            ),
                            Row(
                              children: [
                                Container(
                                    width: 245,
                                    height: 20,
                                    margin: EdgeInsets.only(top: 3, left: 15),
                                    child:
                                    Text("${info.infotext}",
                                      style: TextStyle(
                                          fontSize: 13),
                                    )
                                )
                              ],
                            )
                          ]
                      )
                    ]
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 20, left: 20),
                          child: Icon(Icons.do_not_disturb_alt, size: 35, color: Color(0xff69E2E3))
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, left: 20),
                        width: 70, height: 25,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xffe5e5e5),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: Text("${info.allergy.length > 0 ? info.allergy[0] : "키워드1"}",
                            style: TextStyle(
                                fontSize: 11
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, left: 20),
                        width: 70, height: 25,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xffe5e5e5),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: Text("${info.allergy.length > 1 ? info.allergy[1] : "키워드2"}",
                            style: TextStyle(
                                fontSize: 11
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, left: 20),
                        width: 70, height: 25,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xffe5e5e5),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: Text("${info.allergy.length > 2 ? info.allergy[2] : "키워드3"}",
                            style: TextStyle(
                                fontSize: 11
                            )),
                      )
                    ]
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 12, left: 20),
                          child: Icon(Icons.
                          sentiment_very_satisfied
                              , size: 35, color: Color(0xff69E2E3))
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, left: 20),
                        width: 70, height: 25,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xffa6feff),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: Text("${info.keyword.length > 0 ? info.keyword[0] : "키워드1"}",
                            style: TextStyle(
                                fontSize: 11
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, left: 20),
                        width: 70, height: 25,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xffa6feff),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: Text("${info.keyword.length > 1 ? info.keyword[1] : "키워드2"}",
                            style: TextStyle(
                                fontSize: 11
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12, left: 20),
                        width: 70, height: 25,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: Color(0xffa6feff),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: Text("${info.keyword.length > 2 ? info.keyword[2] : "키워드3"}",
                            style: TextStyle(
                                fontSize: 11
                            )),
                      )
                    ]
                ),
              ),
              Container(
                  height:1.0,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 20),
                  color:Color(0xffe5e5e5)),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(context, "/profile_update");
                    },
                    child:
                    Container(
                        margin: EdgeInsets.only(top: 20, left: 20),
                        child: Icon(Icons.create, size: 33, color: Color(0xff69E2E3))
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(context, "/profile_update");
                    },
                    child:
                    Container(
                        margin: EdgeInsets.only(top: 20, left: 27),
                        child:
                        Text("프로필 수정",
                          style: TextStyle(
                              fontSize: 16),
                        )
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/language');
                    },
                    child:
                    Container(
                        margin: EdgeInsets.only(top: 20, left: 20),
                        child: Icon(Icons.favorite, size: 33, color: Color(0xff69E2E3))
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/like_board');
                      },
                      child:
                      Container(
                          margin: EdgeInsets.only(top: 20, left: 27),
                          child:
                          Text("즐겨찾기",
                            style: TextStyle(
                                fontSize: 16),
                          )
                      )
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/language');
                      },
                      child:
                      Container(
                          margin: EdgeInsets.only(top: 20, left: 20),
                          child: Icon(Icons.translate, size: 33, color: Color(0xff69E2E3))
                      )
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/language');
                      },
                      child:
                      Container(
                          margin: EdgeInsets.only(top: 20, left: 27),
                          child:
                          Text("언어",
                            style: TextStyle(
                                fontSize: 16),
                          )
                      )
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 20, left: 20),
                      child: Icon(Icons.border_color, size: 33, color: Color(0xff69E2E3))
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/list');
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 20, left: 27),
                          child:
                          Text("내가 작성한 리뷰",
                            style: TextStyle(
                                fontSize: 16),
                          )
                      )
                  )
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/customer_center');
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 20, left: 20),
                        child: Icon(Icons.face, size: 33, color: Color(0xff69E2E3))
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/customer_center');
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 20, left: 27),
                        child:
                        Text("고객센터",
                          style: TextStyle(
                              fontSize: 16),
                        )
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async{
                      await viewModel.logout(context);
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 20, left: 20),
                        child: Icon(Icons.logout, size: 33, color: Color(0xff69E2E3))
                    ),
                  ),
                  GestureDetector(
                      onTap: () async{
                        await viewModel.logout(context);
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 20, left: 27),
                          child:
                          Text("로그아웃",
                            style: TextStyle(
                                fontSize: 16),
                          )
                      )
                  ),
                ],
              )
            ]
        ),
      )
    );
  }
}
