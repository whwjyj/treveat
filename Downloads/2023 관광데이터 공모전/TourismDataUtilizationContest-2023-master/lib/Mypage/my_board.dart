import 'package:flutter/material.dart';
import 'package:flutter_app/review/review_view.dart';

class Restaurant {
  final String name;
  final String image;
  final String description;
  final String introduction;
  final String location;
  final String locCode;

  Restaurant({
    required this.name,
    required this.image,
    required this.description,
    required this.introduction,
    required this.location,
    required this.locCode,
  });
}

class ImageDisplay extends StatelessWidget {
  final List<Restaurant> restaurants = [
    Restaurant(
      name: '해운대암소갈비집',
      image:
      'https://ukcooyocdlvo8099722.cdn.ntruss.com/public_data/menu_images/3137299_1638842982_menu.png',
      description:
      'TV조선 식객허영만의백반기행 103회, tvN 수요미식회',
      introduction: '36회 등 방송촬영 여러 방송에서 다룬 바로 그 곳!',
      location: '부산광역시 해운대구',
      locCode: '1241',
    ),
    Restaurant(
      name: '신흥관',
      image:
      'https://ukcooyocdlvo8099722.cdn.ntruss.com/public_data/menu_images/3135089_1638843072_menu.png',
      description: '부산광역시 해운대구에서 어디를 갈지 고민이라면!',
      introduction: '',
      location: '부산광역시 해운대구',
      locCode: '1963',
    ),
    Restaurant(
      name: '평안도족발',
      image:
      'https://ukcooyocdlvo8099722.cdn.ntruss.com/public_data/menu_images/3146579_1638843127_menu.png',
      description: '평안도 지방 특색을 느낄 수 있는 메뉴 다양합니다.',
      introduction: '',
      location: '부산광역시 해운대구',
      locCode: '2561',
    ),
    Restaurant(
      name: '삼다복국',
      image:
      'https://ukcooyocdlvo8099722.cdn.ntruss.com/public_data/menu_images/3068207_1638843247_menu.png',
      description: '매일 먹어도 질리지 않는 국밥 맛집입니다.',
      introduction: '',
      location: '부산광역시 해운대구',
      locCode: '3358',
    ),
    Restaurant(
      name: '해송갈비',
      image:
      'https://ukcooyocdlvo8099722.cdn.ntruss.com/public_data/menu_images/3130382_1638843639_menu.png',
      description: '부드러운 고기와 다양한 구성의',
      introduction: '구이세트를 즐길 수 있습니다.',
      location: '부산광역시 해운대구',
      locCode: '3362',
    ),
    Restaurant(
      name: '홍도횟집',
      image:
      'https://ukcooyocdlvo8099722.cdn.ntruss.com/public_data/menu_images/3164037_1638842691_menu.PNG',
      description: '신선한 해산물 요리로 입맛을 사로잡습니다.',
      introduction: '',
      location: '부산광역시 해운대구',
      locCode: '9930',
    ),
    Restaurant(
      name: '신라횟집',
      image:
      'https://ukcooyocdlvo8099722.cdn.ntruss.com/public_data/menu_images/3167702_1638842499_menu.PNG',
      description:
      '지방자치단체 인증을 받은 받았으며 위생 수준이',
      introduction: ' 우수하고 친절한 서비스로 선정을 받은 모범음식점',
      location: '부산광역시 수영구',
      locCode: '20386',
    ),
    Restaurant(
      name: '서울깍두기',
      image:
      'https://ukcooyocdlvo8099722.cdn.ntruss.com/public_data/menu_images/809965_1638842981_menu.png',
      description:
      '위생 수준이 우수하고 친절한 서비스로',
      introduction: '지방자치단체의 선정을 받은 모범음식점입니다.',
      location: '부산광역시 수영구',
      locCode: '25880',
    ),
    Restaurant(
      name: '촌마을보쌈',
      image:
      'https://ukcooyocdlvo8099722.cdn.ntruss.com/public_data/menu_images/3116047_1638842375_menu.PNG',
      description: '신선한 채소와 고기의 조화',
      introduction: '보쌈의 맛을 만나보세요!',
      location: '부산광역시 사하구',
      locCode: '168780',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Treveat',
          style: TextStyle(color: Color(0xff69E2E3)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TabBarScreen(restaurants[index].locCode.toString())),
              );
              // 가게를 탭했을 때 수행할 동작을 여기에 추가
              // 예를 들어, 해당 가게의 상세 정보 페이지로 이동
            },
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.network(
                    restaurants[index].image,
                    width: 150,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurants[index].name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        restaurants[index].description,
                        style: TextStyle(
                          fontSize: 9,
                        ),
                      ),
                      Text(
                        restaurants[index].introduction,
                        style: TextStyle(
                          fontSize: 9,
                        ),
                      ),
                      Text(
                        restaurants[index].location,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'locCode: ${restaurants[index].locCode}',
                        style: TextStyle(
                          fontSize: 5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}