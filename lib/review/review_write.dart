import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Function/getToday.dart';
import 'package:flutter_app/kakao/user_kakao_info.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';


//서버 Post
Future<String> call(String loc_code, String token_key,String author, String regdate, String rating,
    String content, List<File> pickedimage) async {
  Map<String, String> headers = { "Accesstoken": "access_token"};

  var url = Uri.parse('http://dongseok1.dothome.co.kr/treveat/mReview/insertPage.php');

  http.MultipartRequest request = new http.MultipartRequest("POST", url);
  request.headers.addAll(headers);

  var image_byte1;
  var image_byte2;

  if(pickedimage.length==1){
    image_byte1 = pickedimage[0].readAsBytesSync();
    request.fields['imglink']=base64Encode(image_byte1);
    image_byte1=base64Encode(image_byte1);
  }

  else if(pickedimage.length==2){
    image_byte1 = pickedimage[0].readAsBytesSync();
    request.fields['imglink']=base64Encode(image_byte1);
    image_byte1=base64Encode(image_byte1);

    image_byte2 = pickedimage[1].readAsBytesSync();
    request.fields['imglink2']=base64Encode(image_byte2);
    image_byte2=base64Encode(image_byte2);
  }

  request.fields['loc_code'] = loc_code;
  request.fields['token_key'] = token_key;
  request.fields['author'] = author;
  request.fields['regdate'] = regdate;
  request.fields['rating'] = rating;
  request.fields['content'] = content;

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

class review_write extends StatefulWidget {

  String loc_code_='';
  review_write(this.loc_code_,{Key? key}) : super(key:key);

  @override
  State<review_write> createState() => _review_write();
}

class _review_write extends State<review_write> {
  bool isLoading=false;
  final formkey = GlobalKey<FormState>();

  XFile? _pickedFile1;
  XFile? _pickedFile2;

  List<File> pickedimage = [];

  String response = "";
  String loc_code=""; //일단 선언해두고 아래 build 부분에서 넘겨받은값으로 초기화
  String _token_key = token_key ; //로그인 정보 받아와서 넣기
  String author = name; //로그인 정보 받아와서 넣기
  String regdate = getToday();
  String rating = "0.0";
  String content = "";

  // List<XFile?> imglink= []; //이미지 받아와서 넣기

  @override
  Widget build(BuildContext context) {
    final _imageSize = MediaQuery.of(context).size.width / 4;
    loc_code = widget.loc_code_;

    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }
      },
      child:Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 50,
          backgroundColor: Colors.lightBlueAccent,
          title: Center(
              child: Text('리뷰작성',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ))),
        ),
        body: SingleChildScrollView(
          //폼 전체
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(25, 5, 25, 30),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Column(
                              children: [
                                //별점 표시바
                                RatingBar(
                                  initialRating: 0,
                                  minRating: 0,
                                  maxRating: 5,
                                  allowHalfRating: true,
                                  itemSize: MediaQuery.of(context).size.width/8,
                                  ratingWidget: RatingWidget(
                                    full: const Icon(Icons.star,
                                        color: Colors.lightBlueAccent),
                                    half: const Icon(Icons.star_half,
                                        color: Colors.lightBlueAccent),
                                    empty: const Icon(Icons.star_border,
                                        color: Colors.lightBlueAccent),
                                  ),
                                  onRatingUpdate: (_rating) {
                                    rating = _rating.toString();
                                    //log('rating update to: $_rating'); //$rating = 별점 값
                                  },
                                ),
                              ],
                            ),
                          ),
                          //텍스트 작성 필드
                          TextFormField(
                            autovalidateMode: AutovalidateMode.always,
                            maxLines: 10,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                errorStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blueAccent,
                                ),
                                hintText: "다녀온 리뷰를 정성껏 작성해주세요!!!",
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 2, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 2, color: Colors.black),
                                    borderRadius: BorderRadius.circular(4)),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 2, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 2, color: Colors.black),
                                    borderRadius: BorderRadius.circular(4))),
                            onSaved: (value) {
                              // 내용 작성하면 content에 저장
                              setState(() {
                                content = value as String;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '내용을 입력해주세요';
                              }
                              return null;
                            },
                          ),
                          //사진 가져오기
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Row(
                              children: [
                                if (_pickedFile1 == null)
                                  Container(
                                    height: 80,
                                    constraints: BoxConstraints(
                                      minHeight: _imageSize,
                                      minWidth: _imageSize,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        _getPhotoLibraryImage1();
                                      },
                                      child: Center(
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 60,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      border:
                                      Border.all(width: 2, color: Colors.grey),
                                    ),
                                  )
                                else
                                  Center(
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: _imageSize,
                                            height: _imageSize,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image:
                                                  FileImage(File(_pickedFile1!.path)),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
                                            right: 5,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (_pickedFile2 != null)
                                                    [
                                                      _pickedFile1 = _pickedFile2,
                                                      _pickedFile2 = null,
                                                      pickedimage[0] = pickedimage[1],
                                                      pickedimage.removeLast(),
                                                    ];
                                                  else
                                                    [
                                                      _pickedFile1 = null,
                                                      pickedimage.removeLast(),
                                                    ];
                                                });
                                              },
                                              child: const Icon(
                                                Icons.cancel_rounded,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                SizedBox(
                                  width: 20,
                                ),
                                if (_pickedFile2 == null)
                                  Container(
                                    height: 80,
                                    constraints: BoxConstraints(
                                      minHeight: _imageSize,
                                      minWidth: _imageSize,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        _getPhotoLibraryImage2();
                                      },
                                      child: Center(
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 60,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      border:
                                      Border.all(width: 2, color: Colors.grey),
                                    ),
                                  )
                                else
                                  Center(
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: _imageSize,
                                            height: _imageSize,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image:
                                                  FileImage(File(_pickedFile2!.path)),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
                                            right: 5,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _pickedFile2 = null;
                                                  pickedimage.removeLast();
                                                });
                                              },
                                              child: const Icon(
                                                Icons.cancel_rounded,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            )),
        //작성완료 버튼
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
          child:(isLoading==false)?ElevatedButton(
            onPressed: () async {
              if (formkey.currentState!.validate()) {
                formkey.currentState!.save(); // onSaved()호출?
                setState(() {
                     isLoading=true;
                });
                await call(loc_code,_token_key,author,regdate,rating,content,pickedimage).then((value) => setState(() {
                  response = value;
                }));
                setState(()  {
                  isLoading=false;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          AlertDialog(
                            elevation: 0,
                            backgroundColor: Colors.white,
                            title: Text(response,style: TextStyle(color: Colors.black,fontSize: 18),),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop();
                                    Navigator.of(context)
                                        .pop();
                                    Navigator.of(context)
                                        .pop();
                                  },
                                  child: Text('확인',style:TextStyle(color: Colors.black,fontSize: 14),)),
                            ],
                          ));
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              minimumSize: Size.fromHeight(30), // 높이만 50으로 설정
              shape: RoundedRectangleBorder(
                // shape : 버튼의 모양을 디자인 하는 기능
                  borderRadius: BorderRadius.circular(4.0)),
              shadowColor: Colors.grey,
            ),
            child: Text(
              '작성 완료',
              style: TextStyle(
                  fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ):Center(child:CircularProgressIndicator())
        ),
      ),
    );
  }

  _getPhotoLibraryImage1() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery,maxHeight:280,maxWidth:640,imageQuality: 20);
    if (pickedFile != null) {
      setState(() {
        _pickedFile1 = pickedFile;
        pickedimage.add(File(pickedFile.path));
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  _getPhotoLibraryImage2() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery,maxHeight:280,maxWidth:640,imageQuality: 20);//maxHeight:280,maxWidth:640
    if (pickedFile != null) {
      setState(() {
        if (_pickedFile1 == null)
          [
            _pickedFile1 = pickedFile,
            pickedimage.add(File(pickedFile.path)),
          ];
        else
          [
            _pickedFile2 = pickedFile,
            pickedimage.add(File(pickedFile.path)),
          ];

        //a = File(_pickedFile2!.path);
      });
      // String base = base64Encode(a.readAsBytesSync());
      // print(base);
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }
}
