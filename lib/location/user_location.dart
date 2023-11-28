import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/my_slider.dart';
import '../database/database_methods.dart';


var userId = DatabaseMethods.userId;

class Location extends StatefulWidget {

  static String id = 'user_location_screen';


  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String locationMessage = "Current location of the user";

  late double lat = 23;
  late double long = 89;
  late MapController mapController;
  late List<Marker> markers;
  double selectedRadius = 500;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {

    });
    super.initState();
    mapController = MapController();
    markers = [];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Map"),
      //   centerTitle: true,
      // ),
      body: Center(
        child: Column(
          children: [
            Text(locationMessage),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () async {
                _getCurrentLocation().then((value) {
                  lat = value.latitude;
                  long = value.longitude;
                  setState(() {
                    locationMessage = 'Latitude: $lat, Longitude: $long';
                    lat = value.latitude;
                    long = value.longitude;
                  });
                 // DatabaseMethods().addUserLocation(userId!, lat, long); // Add the location to Firestore
                  _liveLocation();
                });
              },
              child: Text('Get Current Location'),
            ),
            MySlider(
                onSliderChanged: (double value) {
                  selectedRadius = value;
                 // print(value);
                  print(selectedRadius);
                  setState(() {
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: LatLng(lat, long),
                          radius: selectedRadius,
                          useRadiusInMeter: true,
                          color: Colors.lightBlueAccent.withOpacity(0.3),
                          borderColor: Colors.blue.withOpacity(0.65),
                          borderStrokeWidth: 1.5,
                        ),
                      ],
                    );
                  });
                }
            ),
            const SizedBox(
              height: 20.0,
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     _getCurrentLocation().then((value) {
            //       lat = value.latitude;
            //       long = value.longitude;
            //       setState(() {
            //         locationMessage = 'Latitude: $lat , Longitude: $long';
            //       });
            //       _liveLocation();
            //       _openMap(lat.toString(), long.toString());
            //     }
            //     );
            //   },
            //   child: const Text('Open Map'),
            // ),
            Container(
              height: 500,
              color: Colors.black,
              child:  FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: LatLng(lat, long),
                  initialZoom: 16,
                ),
                children: [
                  TileLayer(
                   // circles: [
                    //   CircleMarker(
                    //     point: const LatLng(51.5, -0.09),
                    //     color: Colors.blue.withOpacity(0.7),
                    //     borderColor: Colors.black,
                    //     borderStrokeWidth: 2,
                    //     useRadiusInMeter: true,
                    //     radius: 2000, // 2000 meters
                    //   ),
                    //   CircleMarker(
                    //     point: const LatLng(51.4937, -0.6638),
                    //     // Dorney Lake is ~2km long
                    //     color: Colors.green.withOpacity(0.9),
                    //     borderColor: Colors.black,
                    //     borderStrokeWidth: 2,
                    //     useRadiusInMeter: true,
                    //     radius: 1000, // 1000 meters
                    //   ),
                    // ],
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: markers,
                  ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: LatLng(lat, long),
                        radius: selectedRadius,
                        useRadiusInMeter: true,
                        color: Colors.lightBlueAccent.withOpacity(0.3),
                        borderColor: Colors.blue.withOpacity(0.65),
                        borderStrokeWidth: 1.5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () {
                  //Navigator.pushNamed(context, ResultScreen.id);
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) {
          lat = position!.latitude;
          long = position!.longitude;

          setState(() {
            locationMessage = 'Latitude: $lat , Longitude: $long';
            lat = position!.latitude;
            long = position!.longitude;
            markers = [
              Marker(
                width: 30.0,
                height: 30.0,
                point: LatLng(lat, long),
                child: Container(
                  child: Icon(
                    Icons.location_on,
                    size: 30.0,
                    color: Colors.red,
                  ),
                ),
              ),
             ];
            print(selectedRadius);

            mapController.move(LatLng(lat, long), 16.0);
          });

        });
  }

  Future<void> _openMap(String lat, String long) async {
    final Uri _url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$long');

    //final Uri _url = Uri.parse('https://flutter.dev');

    // await canLaunchUrlString(googleURL)
    //     ? await launchUrlString(googleURL)
    //     : throw 'Could not launch $googleURL';


    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }

  }
}

