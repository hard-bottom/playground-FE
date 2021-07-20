import 'dart:async';
import 'dart:convert'; // json 처리용

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import 'package:playground/pages/page.dart';
import 'package:playground/pages/place_marker.dart';

Future<List<Population>> fetchPopulation() async {

  var currentDt = DateTime.now();
  var hour = DateFormat("HH").format(currentDt);
  var dayOfWeek = DateFormat("EEEE").format(currentDt);

  var params = {
    'day': dayOfWeek.toUpperCase(),
    'time': hour,
  };

  final response =
  await http.get(Uri.http('192.168.35.24:8080','/populations', params));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return compute(parsePopulations, response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load populations');
  }
}


List<Population> parsePopulations(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  print(parsed);

  return parsed.map<Population>((json) => Population.fromJson(json)).toList();
}

class Population {
  final String city;
  final String district;
  final String day;
  final String time;
  final int count;

  Population({
    this.city,
    this.district,
    this.day,
    this.time,
    this.count
  });

  factory Population.fromJson(Map<String, dynamic> json) {
    return Population(
      city: json['city'] as String,
      district: json['district'] as String,
      day: json['day'] as String,
      time: json['time'] as String,
      count: json['count'] as int
    );
  }

}

class FloatingPopulationPage extends AppPage {
  FloatingPopulationPage() : super(const Icon(Icons.place), 'RestAPI Test Page');

  @override
  Widget build(BuildContext context) {
    return const FloatingPopulationPageBody();
  }
}

class FloatingPopulationPageBody extends StatefulWidget {
  const FloatingPopulationPageBody();

  @override
  State<StatefulWidget> createState() => _JSONGetState();
}

class _JSONGetState extends State<FloatingPopulationPageBody> {
  // future는 데이터를 다 받기전에 먼저 데이터가 없이 그릴 수 없는 부분을 먼저 그려주기 위해 사용.
  // future는 비동기 함수처럼 동작하게 함. then은 정상적으로 안에 내용이 수행되었으면 실행할 로직이 들어감
  // CatchError는 해당 함수에서 문제가 발생하면 에러 처리


  @override
  void initState() {
    super.initState();
  }

  Future<String> _fetch1() async {
    await Future.delayed(Duration(seconds: 2));
    return 'Call Data';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Fetch data'),
        ),
        body: FutureBuilder<List<Population>>(
          future: fetchPopulation(),
          builder: (context, snapshot) {
            // 데이터를 정상적으로 받아온 경우 처리되는 곳
            if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 16),
                ),
              );
            } else {
              return snapshot.hasData
                  ? PopulationList(populations: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }
}

class PopulationList extends StatelessWidget {
  final List<Population> populations;

  PopulationList({Key key, this.populations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: populations.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: PlaceMarkerPage(),
              ),
            );
          },
          child: GridTile(
            child: Container(
              color: Colors.blue[(populations[index].count/1000).toInt()]
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              title: Text(populations[index].day + ', ' + populations[index].time),
              subtitle: Text('count: ${populations[index].count}'),
            ),
          ),
        );
      },
    );
  }
}