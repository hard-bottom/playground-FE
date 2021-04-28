import 'package:flutter/material.dart';

class FloatingPopulationPage extends StatefulWidget {
  @override
  _FloatingPopulationPage createState() => _FloatingPopulationPage();
}

class _FloatingPopulationPage extends State<FloatingPopulationPage> {
  final int numOfBorough = 25;
  final int row = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PlayGround")),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: row,
          childAspectRatio: 0.8,
        ),
        itemCount: numOfBorough,
        itemBuilder: (context, index) {
          return _buildPopulationList(context, index);
        },
      )
    );
  }

  Widget _buildPopulationList(BuildContext context, int index) {
    var cl = [Colors.red, Colors.purple, Colors.yellow, Colors.green];

    return Container(
        margin: EdgeInsets.all(30),
        color: cl[index%4],
        child: Center(child: new Text('$index'))
    );
  }
}