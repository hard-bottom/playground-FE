import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:flutter_kakao_map/flutter_kakao_map.dart';
import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';
import 'package:playground/pages/Entry.dart';
import 'pages/page.dart';
import 'pages/place_marker.dart';
import 'pages/floatingPopulationPage.dart';

class PlayGround extends StatelessWidget {
  // root of application
  // Scaffold : 최상단, 중간 영역, 최하단, 떠 있는 버튼(3개) 지원해주는 클래스.
  // appBar : 최상단 바
  // body : 중간 영역(메인)
  // bottomNavigationBar : 하단 바
  // floatingActionButton : 3개 버튼
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Playground',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EntryPage();
  }
}

void main() {
  KakaoContext.clientId = "946b69cdafd72f5a69c1ad2f82b6a799";
  runApp(MaterialApp(home: PlayGround()));
}
