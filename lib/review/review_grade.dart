import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/kakao/user_kakao_info.dart';
import 'package:flutter_app/review/review_modify.dart';
import 'package:http/http.dart' as http;
import '../model/model_review.dart';

enum MenuType {
  modify('수정'),
  delete('삭제');

  const MenuType(this.name);

  final String name;
}

final scrollController=ScrollController();

Future<String> fetchUser(String token_key) async {
  final response = await http.get(Uri.parse(
      'http://dongseok1.dothome.co.kr/treveat/mUsers/selectUsers.php?token_key=$token_key'));

  if (response.statusCode == 200) {
    var responseBody = utf8.decode(response.bodyBytes);
    final json = "${responseBody}"; //responseBody는 {키:값},{키:값}형태
    List list = await (jsonDecode(json) as List<dynamic>);
    return list[0]['profileimg'];
  } else {
    throw Exception('Not Found');
  }
}

Future<List<model_review>> fetchReview(String loc_code, List<String> image) async {
  final response = await http.get(Uri.parse(
      'http://dongseok1.dothome.co.kr/treveat/mReview/selectValue.php?start=0&end=30&rsort=desc&loc_code=$loc_code'));

  if (response.statusCode == 200) {
    var responseBody = utf8.decode(response.bodyBytes);
    final json = "${responseBody}"; //responseBody는 {키:값},{키:값}형태
    List list = await (jsonDecode(json) as List<dynamic>);

    for(int i=0;i<list.length;i++){
      image.add(await fetchUser(list[i]['token_key']));
    }

    return list.map<model_review>((map) => model_review.fromJson(map)).toList();

    //return Post.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Not Found');
  }
}

void deletereview(String no,String author) async {
  final response = await http.get(Uri.parse(
      'http://dongseok1.dothome.co.kr/treveat/mReview/deletePage.php?no=$no&author=$author'));

  if (response.statusCode == 200) {
    print("good");//이 부분에 위젯 추가해서 반환하기?
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Not Found');
  }
}

class riview_grade extends StatefulWidget {
  String loc_code_;
  riview_grade(this.loc_code_,{Key? key}) : super(key:key);

  @override
  State<riview_grade> createState() => _riview_grade();
}

class _riview_grade extends State<riview_grade> {
  late Future<List<model_review>> futurereview; //late : non-nullable 변수의 초기화를 나중에 할 수 있게해줌
  late Future<String> futureUser;

  List<String> image =[];

  @override
  void initState() {
    super.initState();
    futurereview =fetchReview(widget.loc_code_,image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(//Material() 사용하면 탭 안에서만 항목이 열림 반드시 Scaffold만 쓸것!
      body: Center(
        child: FutureBuilder(
          future: futurereview, //작업하고하자는 future -> fetchAlbum()의 리턴값
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<model_review> _review = snapshot.data as List<model_review>;
              return Container(
                  color: Colors.white,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: _review.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Card(
                          elevation: 0,
                          color: Colors.white,
                          child: (() {
                            if (_review[i].token_key == token_key) {
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(image[i]),
                                ),
                                title: Container(
                                  width: MediaQuery.of(context).size.width/5,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text(_review[i].author,
                                            style: TextStyle(
                                                fontWeight:FontWeight.bold,fontSize: 16)),
                                        SizedBox(width: 15),
                                        RatingBar(
                                          //아래 RatingBar 함수 따로 선언
                                          rating: double.parse(_review[i].rating),
                                          ratingCount: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      _review[i].regdate,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(_review[i].content),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          if(_review[i].imglink.isNotEmpty)
                                            Image.memory(base64Decode(_review[i].imglink),width: MediaQuery.of(context).size.width/5),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          if(_review[i].imglink2.isNotEmpty)
                                            Image.memory(base64Decode(_review[i].imglink2),width: MediaQuery.of(context).size.width/5),
                                        ],
                                      ),
                                    )
                                  ],
                                ),

                                trailing: PopupMenuButton<MenuType>(
                                  shadowColor: Colors.grey,
                                  color: Colors.white,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),

                                  child: Container(
                                    width: 20,
                                    height: 30,
                                    child: Icon(
                                      Icons.more_vert,
                                    ),
                                  ),
                                  constraints: const BoxConstraints.expand(
                                      width: 60, height: 105),
                                  onSelected: (MenuType result) {
                                    if (result.name == '수정') {
                                      Navigator.of(context).push(
                                        //push: 다음 화면을 쌓겠다는 의미
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              review_modify(widget.loc_code_,_review[i].no), //materialpageroute: navigator가 이동할 경로 지정
                                        ),
                                      );
                                    } else if (result.name == '삭제') {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                elevation: 0,
                                                title: Text('삭제'),
                                                content: Text('정말 삭제하시겠습니까?',style: TextStyle(color: Colors.black,fontSize: 16,)),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        deletereview(_review[i].no,_review[i].author);
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('네',style: TextStyle(color: Colors.black,fontSize: 14,))),
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child: Text('아니오',style: TextStyle(color: Colors.black,fontSize: 14,))),
                                                ],
                                              ));
                                    }
                                    ;
                                  },
                                  itemBuilder: (BuildContext buildContext) {
                                    return [
                                      for (final value in MenuType.values)
                                        PopupMenuItem(
                                            value: value,
                                            child: Center(
                                              child: Text(value.name),
                                            ) //class명 포함하지 않기위해서 describeEnum()함수 사용
                                        )
                                    ];
                                  },
                                ),

                                isThreeLine:
                                true, //subtitle의 길이가 3줄이 안되어도 3줄 칸 확보
                              );
                            } else {
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(image[i]),
                                ),
                                title: Container(
                                  width: MediaQuery.of(context).size.width/5,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Text(_review[i].author,
                                            style: TextStyle(
                                                fontWeight:FontWeight.bold,fontSize: 16)),
                                        SizedBox(width: 15),
                                        RatingBar(
                                          //아래 RatingBar 함수 따로 선언
                                          rating: double.parse(_review[i].rating),
                                          ratingCount: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      _review[i].regdate,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(_review[i].content),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          if(_review[i].imglink.isNotEmpty)
                                            Image.memory(base64Decode(_review[i].imglink),height: MediaQuery.of(context).size.width/4),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          if(_review[i].imglink2.isNotEmpty)
                                            Image.memory(base64Decode(_review[i].imglink2),height: MediaQuery.of(context).size.width/4),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                isThreeLine:
                                true, //subtitle의 길이가 3줄이 안되어도 3줄 칸 확보
                              );
                            }
                          })(),
                        );
                      }
                      )
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
            //data를 아직 받아 오지 못했을때 실행되는 부분
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final double rating;
  final double size;
  final int ratingCount;

  RatingBar({required this.rating, required this.ratingCount, this.size = 18});

  @override
  Widget build(BuildContext context) {
    List<Widget> _starList = [];

    //int realNumber = rating.floor(); //버림

    for (int i = 1; i <= 5; i++) {
      if(rating==0.0){
        _starList.add(Icon(Icons.star, color: Colors.grey, size: size));
      }
      else {
        if(rating-i>=0.0){
          _starList
              .add(Icon(Icons.star, color: Colors.lightBlue[200], size: size));
        }
        else if(rating-i==-0.5){
          _starList.add(
              Icon(Icons.star_half, color: Colors.lightBlue[200], size: size));
        }
        else{
          _starList.add(Icon(Icons.star, color: Colors.grey, size: size));
        }
      }
    }

    return Row(
      children: _starList,
    );
  }
}