import 'package:flutter/material.dart';

class Language extends StatelessWidget {
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
            Text("해당 서비스는 준비중입니다.",
                style: TextStyle(
                    fontSize: 18)
            )
        )
    );
  }
}