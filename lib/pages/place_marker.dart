import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kakao_map/flutter_kakao_map.dart';
import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';
import 'package:playground/pages/page.dart';
import 'page.dart';

class PlaceMarkerPage extends AppPage {
  PlaceMarkerPage() : super(const Icon(Icons.place), 'marker');
  @override
  Widget build(BuildContext context) {
    return PlaceMarker();
  }
}

class PlaceMarker extends StatefulWidget {
  const PlaceMarker();

  @override
  State<StatefulWidget> createState() => PlaceMarkerState();
}

typedef Marker MarkerUpdateAction(Marker marker);

class PlaceMarkerState extends State<PlaceMarker> {
  PlaceMarkerState();
  static final List<MapPoint> positionList = [ MapPoint(37.24575, 127.05669), MapPoint(37.24719, 127.05489),
    MapPoint(37.24900, 127.05914), MapPoint(37.24713, 127.06244)];
  // 초기 카메라 위치 설정
  static final MapPoint center = const MapPoint(37.253976, 127.055024);
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: MapPoint(37.253976, 127.055024),
    zoom: 5,
  );

  bool _isDrage = false;
  int _markerIdCounter = 1;
  MarkerId selectedMarker;
  MapPoint _visibleRegion = MapPoint(37.253976, 127.055024);
  CameraPosition _position = _kInitialPosition;
  KakaoMapController controller;
  BitmapDescriptor myIcon;
  //final bitmapIcon;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Set<Marker> _markers = {};

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    myIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio:2.5), 'assets/res_icon.png');
  }

  void _updateCameraPosition(CameraPosition position) async {
    //final bitmapIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48,48)), 'assets/photos/res_icon.png');
    print("bitmapIcon get!!!!!!?");
    setState(() {
      _position = position;
      setState(() {
        final String markerIdVal = 'marker_id_$_markerIdCounter';
        _markerIdCounter++;
        final MarkerId markerId = MarkerId(markerIdVal);

        final Marker marker = Marker(
          markerId: markerId,
          position: MapPoint(37.24547, 127.05669),
          icon: this.myIcon,
          infoWindow: InfoWindow(title: "JSJSJS!!", snippet: 'JSJS!'),
          draggable: true,
          onDragEnd: (MapPoint position) {
            _onMarkerDragEnd(markerId, position);
          },
          //markerType: MarkerType.markerTypeBluePin,
          //markerSelectedType: MarkerSelectedType.markerSelectedTypeRedPin,
          //showAnimationType: ShowAnimationType.showAnimationTypeDropFromHeaven,
        );
        markers[markerId] = marker;
      });
    });
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void _onMarkerDragEnd(MarkerId markerId, MapPoint newPosition) async {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 66),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Old position: ${tappedMarker.position}'),
                        Text('New position: $newPosition'),
                      ],
                    )));
          });
    }
  }

  void _allviews() async {
    for (var i = 0; i < positionList.length; i++) {
      final String markerIdVal = 'marker_id_$_markerIdCounter';
      _markerIdCounter++;
      final MarkerId markerId = MarkerId(markerIdVal);

      final Marker marker = Marker(
        markerId: markerId,
        position: positionList[i],
        infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
        //icon: myIcon,
        //visible: true,
        markerType: MarkerType.markerTypeBluePin,
        markerSelectedType: MarkerSelectedType.markerSelectedTypeRedPin,
        showAnimationType: ShowAnimationType.showAnimationTypeDropFromHeaven,
        onTap: () {
          _onMarkerTapped(markerId);
        },
        onDragEnd: (MapPoint position) {
          _onMarkerDragEnd(markerId, position);
        },
      );
      setState(() {
        markers[markerId] = marker;
      });
    }
  }

  void _onMapCreated(KakaoMapController controller) {
    print("onMapCreated!!!!!!!!!!!!!!!!!!@@@@@@@@@@@@@@@@@@");
    this.controller = controller;
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: MapPoint(37.24547, 127.05669),
      icon: this.myIcon,
    );
    setState(() {
      markers[markerId] = marker;
    });
  }

  void _onMarkerSelect(MarkerTag markerId) {}

  @override
  Widget build(BuildContext context) {
    final KakaoMap kakaoMap = KakaoMap(
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      initialCameraPosition: _kInitialPosition,
      onCameraMove: _updateCameraPosition,
      // Set(유일한 element) of는 Iterable<E> elements로 LinkedHashSet 만드는거.. 생성자임.
      onMarkerSelect: _onMarkerSelect,
      markers: Set<Marker>.of(markers.values),
    );

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
              child: SizedBox(
                width: 400.0,
                height: 600.0,
                child: kakaoMap,
              )
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          RaisedButton(
                            child: const Text('view All Markers'),
                            onPressed: _allviews,
                          ),
                          //Tab(icon: new Image.asset("assets/photos/res_icon.png"), text: "resturant"),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ]
    );
  }
}