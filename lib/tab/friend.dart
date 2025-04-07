import 'package:flutter/material.dart';
import 'package:flutter_app/Function/getWord.dart';
import 'package:flutter_app/friend/allergy_friend.dart';
import 'package:flutter_app/friend/search_friend.dart';
import 'package:flutter_app/friend/tour_friend.dart';
import 'package:flutter_app/kakao/user_kakao_info.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/model/model_friend.dart';

Future<List<model_friend>> fetchFriend(List keyword) async {
  final response;

  if(keyword.length==1)
    response = await http.get(Uri.parse(
        'http://dongseok1.dothome.co.kr/treveat/mUsers/selectValue.php?randomcount=5&allergy=${keyword[0]}'));
  else if(keyword.length==2)
    response = await http.get(Uri.parse(
        'http://dongseok1.dothome.co.kr/treveat/mUsers/selectValue.php?randomcount=5&allergy=${keyword[0]},${keyword[1]}'));
  else response = await http.get(Uri.parse(
        'http://dongseok1.dothome.co.kr/treveat/mUsers/selectValue.php?randomcount=5&allergy=${keyword[0]},${keyword[1]},${keyword[2]}'));

  if (response.statusCode == 200) {
    var responseBody = utf8.decode(response.bodyBytes);
    final json = "${responseBody}";
    List list = (jsonDecode(json) as List<dynamic>);
    return list.map<model_friend>((map) => model_friend.fromJson(map)).toList();


  } else {
    throw Exception('Not Found');
  }
}

Future<void> call_Allergy(String keyword) async {
  Map<String, String> headers = { "Accesstoken": "access_token"};

  var url = Uri.parse('http://dongseok1.dothome.co.kr/treveat/insertPage.php');

  http.MultipartRequest request = new http.MultipartRequest("POST", url);
  request.headers.addAll(headers);

  request.fields['keyword'] = keyword;
}

Future<void> call_Tour(String keyword) async {
  Map<String, String> headers = { "Accesstoken": "access_token"};

  var url = Uri.parse('http://dongseok1.dothome.co.kr/treveat/insertPage.php');

  http.MultipartRequest request = new http.MultipartRequest("POST", url);
  request.headers.addAll(headers);

  request.fields['keyword'] = keyword;

}

class Friend extends StatefulWidget {
  @override
  State<Friend> createState() => _Friend();
}

class _Friend extends State<Friend> {
  late Future<List<model_friend>> futurefriend;
  final searchController = TextEditingController();

  final List<String> word1 = ['해산물', '우유', '계란', '메밀', '맥주', '땅콩', '딸기', '갑각류'];
  final List<String> word2 = ['해운대', '바다', '연인', '맥주', '카페', '자전거', '사진', '여행'];
  List<String> Allergy = [];
  List<String> Tour = [];

  @override
  void initState() {
    super.initState();
    Allergy = getword(word1);
    Tour = getword(word2);
    if(allergy.isNotEmpty)
      futurefriend = fetchFriend(allergy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        controller: searchController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => search_friend(//검색 가능 하게끔 생각해보기
                                          searchController.text)));
                            },
                          ),
                          hintText: '알러지 친구를 검색해보세요',
                          contentPadding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(50.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(50.0)),
                            borderSide:
                            BorderSide(width: 2, color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(50.0)),
                            borderSide:
                            BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        onEditingComplete: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      search_friend(searchController.text)));
                        },
                      ),
                    )),
                //추천 검색어
                Container(
                  height: 165,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        )
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                            '추천 검색어',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 4,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        return Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                7, 10, 5, 10),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width/5.1,
                                                  child: ElevatedButton(
                                                    child: Text(
                                                      Allergy[i],
                                                      style: (TextStyle(
                                                          color: Colors.black,fontSize: 12 )),
                                                    ),
                                                    onPressed: () {
                                                      call_Allergy(Allergy[i]);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                allergy_friend(
                                                                    Allergy[i])),

                                                      );
                                                    },
                                                    style:
                                                    ElevatedButton.styleFrom(
                                                      padding: const EdgeInsets.all(5),
                                                      backgroundColor:
                                                      Colors.grey[100],
                                                      shadowColor: Colors.grey,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ));
                                      }))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 4,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        return Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                7, 10, 5, 10),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width/5.1,
                                                  child: ElevatedButton(
                                                    child: Text(
                                                      Tour[i],
                                                      style: (TextStyle(
                                                          color: Colors.black,fontSize: 12 )),
                                                    ),
                                                    onPressed: () {
                                                      call_Tour(Tour[i]);//알러지 키워드 Post
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                tour_friend(
                                                                    Tour[i])), //알러지 키워드 전달

                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      padding: const EdgeInsets.all(5),
                                                      elevation: 0,
                                                      backgroundColor: Colors.white,
                                                      side: BorderSide(
                                                        color: Color(0xff69E2E3),
                                                        width: 2,
                                                      ),
                                                      shadowColor: Colors.grey,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ));
                                      }))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //알러지 친구 추천
                if (allergy.isEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
                        child: Text(
                          '이런 알러지 친구는 어때요?',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      //선택된건 그 값으로 보내고 안된건 NULL로 보낼 수 있도록 생각해보기
                      Padding(padding: EdgeInsets.only(top: 10),
                          child: Center(
                              child:Text('MyPage에서 알러지 키워드를 등록해보세요!')
                          ))
                    ],
                  )
                else
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
                          child: Text(
                            '이런 알러지 친구는 어때요?',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder(
                            future: futurefriend,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<model_friend> _friend =
                                snapshot.data! as List<model_friend>;
                                return Container(
                                    color: Colors.white,
                                    child: ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),//스크롤 제어
                                        padding: EdgeInsets.zero,
                                        itemCount: _friend.length,
                                        itemBuilder: (BuildContext context, int i) {
                                          return ListTile(
                                            leading: CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(_friend[i].profileimg),
                                            ),
                                            title: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    _friend[i].name,//유저 이름
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: 25,
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context).size.width /
                                                        2.0,
                                                    child: Text(
                                                        _friend[i].infotext//유저 인포
                                                    ),
                                                    // decoration: BoxDecoration(
                                                    //     border: Border.all(width: 2)),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }));
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('${snapshot.error}'),
                                );
                              }
                              //data를 아직 받아 오지 못했을때 실행되는 부분
                              return const CircularProgressIndicator();
                            },
                          ),),
                      ],
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}
