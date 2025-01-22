import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/model/model_friend.dart';

Future<List<model_friend>> fetchFriend(String keyword) async {
  print(keyword);
  final response = await http.get(Uri.parse(
      'http://dongseok1.dothome.co.kr/treveat/mUsers/selectValue.php?randomcount=10&tour=$keyword'));

  if (response.statusCode == 200) {
    var responseBody = utf8.decode(response.bodyBytes);
    final json = "${responseBody}"; //responseBody는 {키:값},{키:값}형태
    List list = (jsonDecode(json) as List<dynamic>);
    return list.map<model_friend>((map) => model_friend.fromJson(map)).toList();

    //return Post.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Not Found');
  }
}

class tour_friend extends StatefulWidget {
  String word = '';

  tour_friend(this.word, {Key? key}) : super(key: key);

  @override
  State<tour_friend> createState() => _tour_friend();
}

class _tour_friend extends State<tour_friend> {
  bool isLoading = false;
  late Future<List<model_friend>> futurefriend;

  @override
  void initState() {
    super.initState();
    futurefriend = fetchFriend(widget.word);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('트레빗 친구',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              )),
        ),
        body: Center(
          child:FutureBuilder(
            future: futurefriend,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<model_friend> _friend =
                snapshot.data! as List<model_friend>;
                return Container(
                    color: Colors.white,
                    child: ListView.builder(
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
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
