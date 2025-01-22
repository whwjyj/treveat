import 'package:flutter/material.dart';
import 'package:flutter_app/kakao/login.dart';
import '../kakao/login_view_model.dart';

class login_view extends StatelessWidget {
  final viewModel = loginViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('Treveat', style: TextStyle(color: Color(0xff69E2E3))),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height:1.0,
                width:500.0,
                color:Color(0xffe5e5e5)),
            Row(
              children: [
                GestureDetector(
                  onTap: () async{
                    await viewModel.login(context);
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 20, left: 30),
                      child: Icon(Icons.logout, size: 33, color: Color(0xff69E2E3))
                  ),
                ),
                GestureDetector(
                    onTap: () async{
                      await viewModel.login(context);
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 20, left: 27),
                        child:
                        Text("로그인",
                          style: TextStyle(
                              fontSize: 16),
                        )
                    )
                ),
              ],
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20, left: 30),
                    child: Icon(Icons.textsms, size: 33, color: Color(0xff69E2E3))
                ),
                Container(
                    margin: EdgeInsets.only(top: 20, left: 27),
                    child:
                    Text("이용약관",
                      style: TextStyle(
                          fontSize: 16),
                    )
                )
              ],
            )
          ],
      ),
    );
  }
}
