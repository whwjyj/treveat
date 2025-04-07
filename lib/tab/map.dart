import 'package:flutter/material.dart';
import 'package:flutter_app/review/review_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

Xml2Json xml2json = new Xml2Json();
XmlDocument? XmlData;

void main() => runApp(MaterialApp(home: MapScreen())); //MapScreen 페이지를 실행시킴

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
    loadMarkers(); // 앱 시작시 마커 불러오기
  }

  Future<void> loadMarkers() async {
    final apiKey = 'PmBLn80WCCllUdLedclwIysnCuD4s7oow6pTP9EwnLbhMU7Ow2K354qef62KFaLX';
    final apiUrl1 = 'https://busan-7beach.openapi.redtable.global/api/rstr?serviceKey=$apiKey';
    final apiUrl2 = 'https://apis.data.go.kr/B551011/ForFriTourService/locationBasedList?serviceKey=IxreiIb7cGDnUhnmDbaWO6LyNur8uwjXM470XpZzGhnXhdMA3ui%2FNKZp9IQvPFWFgWeDZ6JBCC15R3UJCMOU2Q%3D%3D&MobileOS=AND&MobileApp=test&mapX=129.0756&mapY=35.1796&radius=100000';

    final responses = await Future.wait([
      http.get(Uri.parse(apiUrl1)),
      http.get(Uri.parse(apiUrl2)),
    ]); // API 병렬 처리함

    if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
      final jsonData1 = json.decode(responses[0].body);
      for (var restaurant in jsonData1['body']) {
        double lat = double.parse(restaurant['RSTR_LA']);
        double lng = double.parse(restaurant['RSTR_LO']);
        String name = restaurant['RSTR_NM'];
        String snippet = restaurant['RSTR_INTRCN_CONT'];

        MyMarker marker = MyMarker(
          id: MarkerId(name),
          name: name,
          position: LatLng(lat, lng),
          snippet: snippet, 
          rstrId: '',
        );

        _markers.add(marker);
      } // josn 처리

      final responsebody = utf8.decode(responses[1].bodyBytes);
      xml2json.parse(responsebody);
      var jsondata = xml2json.toParker();
      var data = json.decode(jsondata);

      for (Map<String, dynamic> restaurant in data['response']['body']['items']['item']) {
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
      } // xml 처리

      _filteredMarkers = List.from(_markers); // 필터링

      setState(() {}); // 마커 리스트가 갱신되면 업데이트
    } else {
      throw Exception('Failed to load markers from API');
    }
  }

  void showMarkerInfo(MyMarker marker) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return MarkerInfoPage(marker: marker);
        },
      ),
    );
  }

  void _search() {
    String searchKeyword = _searchController.text;
    String englishSearchKeyword = Intl.message(searchKeyword, name: 'searchKeyword');

    _filteredMarkers = List.from(_markers);

    List<MyMarker> filteredMarkers = _filteredMarkers
        .where((marker) => marker.name.toLowerCase().contains(englishSearchKeyword.toLowerCase()))
        .toList();

    setState(() {
      _filteredMarkers.clear();
      _filteredMarkers.addAll(filteredMarkers);
    }); // 필터링된 마커들만 화면에 보여줌

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
  } // 버튼 누르면 부산 중심으로 이동

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
                  showMarkerInfo(marker); // 마커를 탭했을 때 정보 페이지를 표시
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
          Align( // 부산 버튼
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
  String rstrId;

  MyMarker({
    required this.id,
    required this.name,
    required this.position,
    required this.snippet,
    required this.rstrId,
  });
} // 커스텀을 위한 마커 클래스

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
    } // 해당 식당 ID를 가져오는 함수

    return null;
  }

  @override // 마커 상세 정보 보여주는 페이지
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
            }

            if (rstrIdSnapshot.hasData) {
              marker.rstrId = rstrIdSnapshot.data ?? '';
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  marker.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  marker.snippet,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text('Restaurant ID: ${marker.rstrId}'),
              ],
            );
          },
        ),
      ),
    );
  }
}
