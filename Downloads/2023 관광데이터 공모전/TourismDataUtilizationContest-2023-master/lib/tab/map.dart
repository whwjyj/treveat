import 'package:flutter/material.dart';
import 'package:flutter_app/review/review_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

Xml2Json xml2json = new Xml2Json();  //Make an instance.
XmlDocument? XmlData;

void main() => runApp(MaterialApp(home: MapScreen()));

class MapScreen extends StatefulWidget {
  @override
  _MapWithMarkersState createState() => _MapWithMarkersState();
}

class _MapWithMarkersState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  List<MyMarker> _markers = [];
  List<MyMarker> _filteredMarkers = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // API에서 데이터 가져오고 마커 생성
    loadMarkers();
    createMarkers();
  }

  Future<void> loadMarkers() async {
    // API 호출
    final apiKey = 'PmBLn80WCCllUdLedclwIysnCuD4s7oow6pTP9EwnLbhMU7Ow2K354qef62KFaLX';
    final apiUrl = 'https://busan-7beach.openapi.redtable.global/api/rstr?serviceKey=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      // JSON 데이터를 기반으로 MyMarker 객체를 생성합니다.
      for (var restaurant in jsonData['body']) {
        double lat = double.parse(restaurant['RSTR_LA']);
        double lng = double.parse(restaurant['RSTR_LO']);
        String name = restaurant['RSTR_NM'];
        String snippet = restaurant['RSTR_INTRCN_CONT'];

        MyMarker marker = MyMarker(
          id: MarkerId(name),
          name: name,
          position: LatLng(lat, lng),
          snippet: snippet, rstrId: '',
        );

        _markers.add(marker);
      }

      // 모든 마커를 로드한 후, _filteredMarkers를 초기화합니다.
      _filteredMarkers = List.from(_markers);

      setState(() {});
    } else {
      throw Exception('Failed to load markers from API');
    }
  }

  void showMarkerInfo(MyMarker marker) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          // 해당 마커 정보를 표시하는 페이지를 반환합니다.
          return MarkerInfoPage(marker: marker);
        },
      ),
    );
  }

  void _search() {
    String searchKeyword = _searchController.text;
    String englishSearchKeyword = Intl.message(searchKeyword, name: 'searchKeyword');

    // 기존 마커 목록을 _filteredMarkers로 복사합니다.
    _filteredMarkers = List.from(_markers);

    // 검색어로 필터링된 마커 목록을 생성
    List<MyMarker> filteredMarkers = _filteredMarkers
        .where((marker) => marker.name.toLowerCase().contains(englishSearchKeyword.toLowerCase()))
        .toList();

    // 기존 마커 목록을 모두 비우고 검색 결과로 업데이트
    setState(() {
      _filteredMarkers.clear();
      _filteredMarkers.addAll(filteredMarkers);
    });

    // 검색한 위치로 지도 이동
    if (filteredMarkers.isNotEmpty && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          filteredMarkers[0].position,
          14.0,
        ),
      );
    }
  }

  void _moveToBusanCenter() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(35.1796, 129.0756),
          14.0,
        ),
      );
    }
  }

  Future<void> createMarkers() async{
    // API 호출
    final apiUrl = 'https://apis.data.go.kr/B551011/ForFriTourService/locationBasedList?serviceKey=IxreiIb7cGDnUhnmDbaWO6LyNur8uwjXM470XpZzGhnXhdMA3ui%2FNKZp9IQvPFWFgWeDZ6JBCC15R3UJCMOU2Q%3D%3D&MobileOS=AND&MobileApp=test&mapX=129.0756&mapY=35.1796&radius=100000';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final responsebody=utf8.decode(response.bodyBytes);
      xml2json.parse(responsebody);
      var jsondata=xml2json.toParker();
      var data=json.decode(jsondata);

      for (Map<String, dynamic> restaurant in data['response']['body']['items']['item']){
          double lat = double.parse(restaurant['mapy']);
          double lng = double.parse(restaurant['mapx']);
          String name = restaurant['title'];
          String snippet = restaurant['addr1'];

          MyMarker marker = MyMarker(
            id: MarkerId(name),
            name: name,
            position: LatLng(lat, lng),
            snippet: snippet,
            rstrId: '',
          );

          _markers.add(marker);

      }
      // 모든 마커를 로드한 후, _filteredMarkers를 초기화합니다.
      _filteredMarkers = List.from(_markers);
      setState(() {});
    }
    else {
      throw Exception('Failed to load markers from API');
    }
  }

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
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(35.1796, 129.0756),
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _mapController = controller;
            },
            markers: _filteredMarkers
                .map(
                  (marker) => Marker(
                markerId: marker.id,
                position: marker.position,
                infoWindow: InfoWindow(
                  title: marker.name,
                  snippet: marker.snippet,
                ),
                onTap: () {
                  // 마커를 탭했을 때 정보 페이지를 표시
                  showMarkerInfo(marker);
                },
              ),
            )
                .toSet(),
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onEditingComplete: _search,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _moveToBusanCenter();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 36,
                    ),
                    Text(
                      'Busan',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyMarker {
  final MarkerId id;
  final String name;
  final LatLng position;
  final String snippet;
  String rstrId; // 수정: 더 이상 null로 초기화하지 않음

  MyMarker({
    required this.id,
    required this.name,
    required this.position,
    required this.snippet,
    required this.rstrId, // 수정: 생성자에서 rstrId를 받도록 변경
  });
}

class MarkerInfoPage extends StatelessWidget {
  final MyMarker marker;

  MarkerInfoPage({required this.marker});

  Future<String?> fetchRstrId() async {
    final storeName = marker.name;
    const apiKey = 'PmBLn80WCCllUdLedclwIysnCuD4s7oow6pTP9EwnLbhMU7Ow2K354qef62KFaLX';
    final apiUrl =
        'https://busan-7beach.openapi.redtable.global/api/rstr?serviceKey=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final body = jsonData['body'];

      if (body.isNotEmpty) {
        final restaurant = body.firstWhere((item) => item['RSTR_NM'] == storeName, orElse: () => null);
        if (restaurant != null) {
          final rstrId = restaurant['RSTR_ID'].toString();
          return rstrId;
        }
      }
    }

    return null; // 오류 시 null 반환
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(marker.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<String?>(
          future: fetchRstrId(),
          builder: (context, rstrIdSnapshot) {
            if (rstrIdSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (rstrIdSnapshot.hasError) {
              return Text('Error: ${rstrIdSnapshot.error}');
            } else {
              final rstrId = rstrIdSnapshot.data;

              if (rstrId != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '가게 이름: ${marker.name}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '가게 소개: ${marker.snippet}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TabBarScreen(rstrId),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                      child: Text('리뷰 보기',style: TextStyle(color: Colors.white,fontSize: 14)),
                    ),
                  ],
                );
              } else {
                return Text('RSTR_ID not available.');
              }
            }
          },
        ),
      ),
    );
  }
}