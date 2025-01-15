import 'package:flutter/material.dart';
import 'package:flutter_app/review/review_recent.dart';
import 'package:flutter_app/review/review_write.dart';
import 'package:flutter_app/tab/mypage.dart';
import '../kakao/user_kakao_info.dart';
import 'review_grade.dart';

class TabBarScreen extends StatefulWidget {
  String loc_code='';
  TabBarScreen(this.loc_code,{Key? key}) : super(key:key);

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,

    // 탭 변경 애니메이션 시간
    animationDuration: const Duration(milliseconds: 00),
  );

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _tabBar(),
          _Expanded(),
        ],
      ),
      floatingActionButton: FloatingActionButton( //로그인 작성 버튼
        onPressed: () {
          if(token_key.isEmpty)
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    AlertDialog(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      title: Text('로그인 후 이용해주세요',style: TextStyle(color: Colors.black,fontSize: 18),),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop();//이걸로해보고 안되면 pop 2번하기
                            },
                            child: Text('확인',style:TextStyle(color: Colors.black,fontSize: 14),)),
                      ],
                    ));
          else
            Navigator.of(context).push( //push: 다음 화면을 쌓겠다는 의미
              MaterialPageRoute(builder: (BuildContext context) => review_write(widget.loc_code), //materialpageroute: navigator가 이동할 경로 지정
              ),
            );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(Icons.edit),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      height: 80,
      child: TabBar(
        controller: tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,

        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.black,

        onTap: (index) {},
        tabs: const [
          Tab(text: "평점순"),
          Tab(text: "최신순"),
        ],
      ),
    );
  }

  Widget _Expanded() {
    return Expanded(
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          riview_grade(widget.loc_code),
          riview_recent(widget.loc_code),
        ],
      ),
    );
  }
}
