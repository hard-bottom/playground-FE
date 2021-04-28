import 'package:flutter/material.dart';

// Color
const MaterialColor myWhite = const MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0x0FFFFFFF),
    100: Color(0x1FFFFFFF),
    200: Color(0x2FFFFFFF),
    300: Color(0x3FFFFFFF),
    400: Color(0x4FFFFFFF),
    500: Color(0x5FFFFFFF),
    600: Color(0x6FFFFFFF),
    700: Color(0x7FFFFFFF),
    800: Color(0x8FFFFFFF),
    900: Color(0x9FFFFFFF),
  },
);

const MaterialColor myBlack = const MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(0xFF000000),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);

// Borough 25개 구
const List<String> boroughNameList = [
  '강남구', '강동구', '강서구', '강북구', '관악구',
  '광진구', '구로구', '금천구', '노원구', '동대문구',
  '도봉구', '동작구', '마포구', '서대문구', '성동구',
  '성북구', '서초구', '송파구', '영등포구', '용산구',
  '양천구', '은평구', '종로구', '중구', '중랑구'
];