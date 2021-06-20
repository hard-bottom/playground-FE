import 'dart:async';
import 'dart:convert'; // json 처리용

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:page_transition/page_transition.dart';

import 'package:playground/pages/page.dart';
import 'package:playground/pages/place_marker.dart';

Future<List<Album>> fetchAlbum() async {
  final response =
  await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return Album.fromJson(jsonDecode(response.body));
    return compute(parsePhotos, response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

List<Album> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Album>((json) => Album.fromJson(json)).toList();
}

class Album {
  final int userId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Album({
    this.userId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl
  });

  // singleton pattern으로 쓰고싶을때 factory keyword
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
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
        body: FutureBuilder<List<Album>>(
          future: fetchAlbum(),
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
                  ? PhotosList(photos: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Album> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: photos.length,
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
            child: FadeInImage(
              placeholder: AssetImage('assets/placeholder.png'),
              image: NetworkImage(photos[index].thumbnailUrl),
              fit: BoxFit.cover,
            ),
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              title: Text(photos[index].title),
              subtitle: Text('id: ${photos[index].id}'),
            ),
          ),
        );
      },
    );
  }
}