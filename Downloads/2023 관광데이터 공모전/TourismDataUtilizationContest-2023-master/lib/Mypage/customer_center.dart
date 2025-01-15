import 'package:flutter/material.dart';

class Customer_center extends StatelessWidget {
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
        body: Container(
          margin: EdgeInsets.only(top: 20, left: 30, right: 30),
          child:
            Text("문의사항은 cryduswjd@naver.com 으로\n메일 보내주시면,\n확인 즉시 답변드리겠습니다.",
            style: TextStyle(
                fontSize: 18)
            )
        )
    );
  }
}