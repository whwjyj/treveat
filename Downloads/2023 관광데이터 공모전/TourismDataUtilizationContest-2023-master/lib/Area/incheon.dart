import 'package:flutter/material.dart';

class Incheon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('this is second screen'),
              OutlinedButton(onPressed: (){
                //뒤로가기 구현 by pop
                Navigator.of(context).pop();

              }, child: Text('go to first screen'))
            ],
          ),
        )
    );
  }
}