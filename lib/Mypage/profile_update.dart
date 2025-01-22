import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_app/Mypage/tour_choice.dart';
import 'package:flutter_app/kakao/login.dart';
import '../kakao/login_view_model.dart';
import 'package:flutter_app/kakao/user_kakao_info.dart' as info;
import 'package:http/http.dart' as http;

import 'allergy_choice.dart';

//서버 Post
Future<String> call(String no, String name, String token_key, String infotext, String profileimg, String allergy,
    String tour, String email) async {
  Map<String, String> headers = { "Accesstoken": "access_token"};

  var url = Uri.parse('http://dongseok1.dothome.co.kr/treveat/mUsers/modifyPage.php');

  http.MultipartRequest request = new http.MultipartRequest("POST", url);
  request.headers.addAll(headers);

  request.fields['no'] = no;
  request.fields['name'] = name;
  request.fields['token_key'] = token_key;
  request.fields['infotext'] = infotext;
  request.fields['profileimg'] = profileimg;
  request.fields['allergy'] = allergy;
  request.fields['tour'] = tour;
  request.fields['email'] = email;

  var response = await request.send();

  final responsebody = await response.stream.bytesToString(); //response -> string으로 변환

  print(responsebody); //값 제대로 전송되는지 체크용

  if (response.statusCode == 200) {
    return '작성이 완료되었습니다.';
  }
  else {
    return '작성에 실패하였습니다.';
  }
}

class Profile_update extends StatefulWidget {
  const Profile_update({Key? key}) : super(key: key);

  @override
  _Profile_update createState() => _Profile_update();
}

class _Profile_update extends State<Profile_update> {
  final viewModel = loginViewModel(KakaoLogin());
  var namevalue = "";
  var infotextvalue = "";

  List<String> _value_allergy = [];
  void _update_allergy() {
    setState(() {
      _value_allergy = info.allergy;
    });
  }

  List<String> _value_keyword = [];
  void _update_keyword() {
    setState(() {
      _value_keyword = info.keyword;
    });
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    Navigator.pop(context, false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text('Treveat', style: TextStyle(color: Color(0xff69E2E3))),
        ),
        body:
          Column(
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
                                margin: EdgeInsets.only(top: 25, left: 20),
                                child:
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(info.profileimg),
                                ),
                              ),
                            ]
                        ),
                        Column(
                            children: [
                              Row(
                                  children: [
                                    Container(
                                      width: 245,
                                      height: 55,
                                      margin: EdgeInsets.only(top: 5, left: 15),
                                      child:
                                      TextField(
                                          decoration: InputDecoration(
                                            labelText: 'name',
                                          ),
                                          onChanged: (text){
                                            namevalue = text;
                                          }
                                      ),
                                    )
                                  ]
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 245,
                                    height: 55,
                                    margin: EdgeInsets.only(top: 3, left: 15),
                                    child:
                                    TextField(
                                        decoration: InputDecoration(
                                          labelText: 'infotext',
                                        ),
                                        onChanged: (text){
                                          infotextvalue = text;
                                        }
                                    ),
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
                  child:Row(
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
                        ),
                        GestureDetector(
                            onTap: () async {
                              bool isBack = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => Allergy_choice()));
                              if (isBack) {
                                _update_allergy();
                              }
                            },
                            child:
                            Container(
                                margin: EdgeInsets.only(top: 20, left: 20),
                                child: Icon(Icons.check_box, size: 20, color: Color(0xffe5e5e5))
                            )
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
                        ),
                        GestureDetector(
                            onTap: () async {
                              bool isBack = await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => Tour_choice()));
                              if (isBack) {
                                _update_keyword();
                              }
                            },
                            child:
                            Container(
                                margin: EdgeInsets.only(top: 15, left: 20),
                                child: Icon(Icons.check_box, size: 20, color: Color(0xff69E2E3))
                            )
                        )
                      ]
                  ),
                ),
                Container(
                    height:1.0,
                    width:500.0,
                    margin: EdgeInsets.only(top: 20, bottom: 15),
                    color:Color(0xffe5e5e5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20),
                    ElevatedButton(
                        child: Text('저장'),
                        onPressed: () async {
                          info.name = namevalue!='' ? namevalue : info.name;
                          info.infotext = infotextvalue!='' ? infotextvalue : info.infotext;
                          String no = info.no;
                          String name = info.name;
                          String token_key = info.token_key;
                          String infotext = info.infotext;
                          String profileimg = info.profileimg;
                          String allergy = info.allergy.join(", ");
                          String tour = info.keyword.join(", ");
                          String email = info.email;

                          await call(no, name, token_key, infotext, profileimg, allergy, tour, email);

                          info.allergy = List.from(_value_allergy);
                          info.keyword = List.from(_value_keyword);
                          Navigator.pop(context, true);
                        }
                    )
                  ],
                ),
              ],
          ),
        )
    );
  }
}