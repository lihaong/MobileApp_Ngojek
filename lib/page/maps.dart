import 'dart:math' show atan2, cos, pi, sin, sqrt;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'payment.dart';
import 'package:intl/intl.dart';
import 'package:uastpm/main.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final rupiahFormat = NumberFormat('#,###');
  final usdFormat = NumberFormat('#,##0.00');
  int _polylineCount = 1;
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};

  final GoogleMapPolyline _googleMapPolyline = GoogleMapPolyline(
    apiKey: "*",
  );

  //Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  final LatLng _mapInitLocation = LatLng(latitude, longitude) ;

  LatLng? _originLocation;
  LatLng? _destinationLocation;

  double _distance = 0.0;
  bool _isEstimated = false;

  _onMapCreated(GoogleMapController controller) {
    setState(() {});
  }

  _getPolylinesWithLocation() async {
    if (_originLocation == null || _destinationLocation == null) {
      _isEstimated = false;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please select both origin and destination locations.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }
    _isEstimated = true;

    List<LatLng>? coordinates = await _googleMapPolyline.getCoordinatesWithLocation(
      origin: _originLocation!,
      destination: _destinationLocation!,
      mode: RouteMode.driving,
    );

    _calculateDistance(coordinates);

    setState(() {
      _polylines.clear();
    });
    _addPolyline(coordinates);


  }


  double _distanceBetween(LatLng from, LatLng to) {
    const int earthRadius = 6371000; // in meters

    double lat1 = from.latitude * (pi / 180.0);
    double lon1 = from.longitude * (pi / 180.0);
    double lat2 = to.latitude * (pi / 180.0);
    double lon2 = to.longitude * (pi / 180.0);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = (earthRadius * c);

    return distance;
  }

  _calculateDistance(List<LatLng>? coordinates) {
    double distance = 0.0;
    if (coordinates != null && coordinates.length > 1) {
      for (int i = 0; i < coordinates.length - 1; i++) {
        LatLng from = coordinates[i];
        LatLng to = coordinates[i + 1];
        distance += _distanceBetween(from, to);
      }
    }
    setState(() {
      _distance = distance;
    });
  }

  _addPolyline(List<LatLng>? coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
      polylineId: id,
      patterns: patterns[0],
      color: Colors.blueAccent,
      points: coordinates!,
      width: 10,
      onTap: () {},
    );

    setState(() {
      _polylines[id] = polyline;
      _polylineCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _originLocation = null;
                _destinationLocation = null;
                _polylines.clear();
                _distance = 0.0;
                _isEstimated = false;
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 145,
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  polylines: Set<Polyline>.of(_polylines.values),
                  initialCameraPosition: CameraPosition(
                    target: _mapInitLocation ,
                    zoom: 15,
                  ),
                  onLongPress: (LatLng latLng) {
                    if (_originLocation == null) {
                      setState(() {
                        _originLocation = latLng;
                      });
                    } else if (_destinationLocation == null) {
                      setState(() {
                        _destinationLocation = latLng;
                      });
                    }
                  },
                  markers: {
                    if (_originLocation != null)
                      Marker(
                        markerId: MarkerId('origin'),
                        position: _originLocation!,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure,
                        ),
                      ),
                    if (_destinationLocation != null)
                      Marker(
                        markerId: MarkerId('destination'),
                        position: _destinationLocation!,
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed,
                        ),
                      ),
                  },
                ),
                if (_distance > 0.0 && _originLocation != null && _destinationLocation != null)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Distance: ${_distance.toStringAsFixed(0)} meters',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          Text(
                            'Price in Rupiah: Rp.${rupiahFormat.format(300 * (_distance / 5))}',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          Text(
                            'Price in USD: \$ ${usdFormat.format(0.002 * (_distance / 5))}',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isEstimated)
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      distance: _distance,
                      priceInRupiah: 300 * (_distance / 10),
                      priceInUSD: 0.002 * (_distance / 10),
                    ),
                  ),
                );
              },
              label: Text('Order'),
              icon: Icon(Icons.add),
              backgroundColor: Colors.lightGreen,
            ),
          SizedBox(height: 8),
          FloatingActionButton.extended(
            onPressed: () {
              _getPolylinesWithLocation();
            },
            label: Text('Estimate'),
            icon: Icon(Icons.search),
            backgroundColor: Colors.orange,

          ),
          SizedBox(height: 16),

        ],
      ),
    );
  }
}
