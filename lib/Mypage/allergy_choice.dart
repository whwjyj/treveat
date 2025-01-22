import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/kakao/user_kakao_info.dart' as info;

class Allergy_choice extends StatefulWidget {
  const Allergy_choice({Key? key}) : super(key: key);

  @override
  _Allergy_choice createState() => _Allergy_choice();
}

class _Allergy_choice extends State<Allergy_choice> {
  bool _isCheck1 = false;
  bool _isCheck2 = false;
  bool _isCheck3 = false;
  bool _isCheck4 = false;
  bool _isCheck5 = false;
  bool _isCheck6 = false;
  bool _isCheck7 = false;
  bool _isCheck8 = false;

  int count_choice = 0;
  List<String> list = [];

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
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text('Treveat', style: TextStyle(color: Color(0xff69E2E3))),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isCheck1,
                        onChanged: (value) {
                          if (list.length >= 3) {
                            Fluttertoast.showToast(
                                msg: "최대 3개까지 가능 합니다.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          } else {
                            setState(() {
                              _isCheck1 = value!;
                              if (_isCheck1) {
                                // 체크되면 해당 값을 리스트에 추가
                                list.add("해산물");
                              } else {
                                // 체크 해제되면 해당 값을 리스트에서 제거
                                list.remove("해산물");
                              }
                            });
                          }
                        },
                      ),
                      Text("해산물")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isCheck2,
                        onChanged: (value) {
                          if (list.length >= 3) {
                            Fluttertoast.showToast(
                                msg: "최대 3개까지 가능 합니다.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          } else {
                            setState(() {
                              _isCheck2 = value!;
                              if (_isCheck2) {
                                // 체크되면 해당 값을 리스트에 추가
                                list.add("우유");
                              } else {
                                // 체크 해제되면 해당 값을 리스트에서 제거
                                list.remove("우유");
                              }
                            });
                          }
                        },
                      ),
                      Text("우유")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isCheck3,
                        onChanged: (value) {
                          if (list.length >= 3) {
                            Fluttertoast.showToast(
                                msg: "최대 3개까지 가능 합니다.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          } else {
                            setState(() {
                              _isCheck3 = value!;
                              if (_isCheck3) {
                                // 체크되면 해당 값을 리스트에 추가
                                list.add("계란");
                              } else {
                                // 체크 해제되면 해당 값을 리스트에서 제거
                                list.remove("계란");
                              }
                            });
                          }
                        },
                      ),
                      Text("계란")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isCheck4,
                        onChanged: (value) {
                          if (list.length >= 3) {
                            Fluttertoast.showToast(
                                msg: "최대 3개까지 가능 합니다.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          } else {
                            setState(() {
                              _isCheck4 = value!;
                              if (_isCheck4) {
                                // 체크되면 해당 값을 리스트에 추가
                                list.add("메밀");
                              } else {
                                // 체크 해제되면 해당 값을 리스트에서 제거
                                list.remove("메밀");
                              }
                            });
                          }
                        },
                      ),
                      Text("메밀")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isCheck5,
                        onChanged: (value) {
                          if (list.length >= 3) {
                            Fluttertoast.showToast(
                                msg: "최대 3개까지 가능 합니다.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          } else {
                            setState(() {
                              _isCheck5 = value!;
                              if (_isCheck5) {
                                // 체크되면 해당 값을 리스트에 추가
                                list.add("맥주");
                              } else {
                                // 체크 해제되면 해당 값을 리스트에서 제거
                                list.remove("맥주");
                              }
                            });
                          }
                        },
                      ),
                      Text("맥주")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isCheck6,
                        onChanged: (value) {
                          if (list.length >= 3) {
                            Fluttertoast.showToast(
                                msg: "최대 3개까지 가능 합니다.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          } else {
                            setState(() {
                              _isCheck6 = value!;
                              if (_isCheck6) {
                                // 체크되면 해당 값을 리스트에 추가
                                list.add("땅콩");
                              } else {
                                // 체크 해제되면 해당 값을 리스트에서 제거
                                list.remove("땅콩");
                              }
                            });
                          }
                        },
                      ),
                      Text("땅콩")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isCheck7,
                        onChanged: (value) {
                          if (list.length >= 3) {
                            Fluttertoast.showToast(
                                msg: "최대 3개까지 가능 합니다.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          } else {
                            setState(() {
                              _isCheck7 = value!;
                              if (_isCheck7) {
                                // 체크되면 해당 값을 리스트에 추가
                                list.add("딸기");
                              } else {
                                // 체크 해제되면 해당 값을 리스트에서 제거
                                list.remove("딸기");
                              }
                            });
                          }
                        },
                      ),
                      Text("딸기")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isCheck8,
                        onChanged: (value) {
                          if (list.length >= 3) {
                            Fluttertoast.showToast(
                                msg: "최대 3개까지 가능 합니다.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          } else {
                            setState(() {
                              _isCheck8 = value!;
                              if (_isCheck8) {
                                // 체크되면 해당 값을 리스트에 추가
                                list.add("갑각류");
                              } else {
                                // 체크 해제되면 해당 값을 리스트에서 제거
                                list.remove("갑각류");
                              }
                            });
                          }
                        },
                      ),
                      Text("갑각류")
                    ],
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: 20),
                    ElevatedButton(
                        child: Text('저장'),
                        onPressed: () {
                          info.allergy = List.from(list);
                          Navigator.pop(context, true);
                        }
                    )
                  ],
                ),
                SizedBox(
                  height: 250,
                )
              ],
            ),
          )
        )
      )
    );
  }
}