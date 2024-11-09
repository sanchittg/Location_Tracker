import 'package:flutter/material.dart';

import 'package:my_map/screen/HomeScreen.dart';
import 'package:my_map/service/UserService.dart';
import 'package:my_map/screen/MapPage.dart';
import 'package:my_map/service/LocationService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';

class MapPageState extends State<MapPage> {
  bool _isLoading = true;
  BitmapDescriptor? _markerIcon;
  late Future<List<dynamic>> locations;
  //late GoogleMapController mapController;

  MapPageState();

  LocationService locationService = LocationService();

  @override
  void initState() {
    super.initState();
    locations = locationService.fetchLocation(widget.user['_id']);
    _getNetworkImageMarker(widget.user['profile_picture'] ??
        'https://cdn-icons-png.flaticon.com/512/3135/3135768.png');
  }

  _getNetworkImageMarker(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    // Resize the image to 80x80
    final resizedBytes = await _resizeImage(bytes, 80, 80);
    final BitmapDescriptor customIcon =
        await BitmapDescriptor.fromBytes(resizedBytes);
    setState(() {
      _markerIcon = customIcon;
    });
  }

  Future<Uint8List> _resizeImage(Uint8List bytes, int width, int height) async {
    // Load the image from bytes
    final img = await _loadImageFromBytes(bytes);

    // Resize the image to 80x80
    final resizedImage = await _resizeToBytes(img, width, height);

    return resizedImage;
  }

  // Convert bytes to image
  Future<ui.Image> _loadImageFromBytes(Uint8List bytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  // Resize the image to the required size
  Future<Uint8List> _resizeToBytes(
      ui.Image image, int width, int height) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
        recorder,
        Rect.fromPoints(
            Offset(0, 0), Offset(width.toDouble(), height.toDouble())));
    final paint = Paint();

    // Draw the image onto the canvas with the desired size
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      paint,
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(width, height);

    // Convert the image to bytes
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.user['first_name']} ${widget.user['last_name']}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: locations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data found"));
          } else {
            return Scaffold(
              body: Stack(
                children: [
                  GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                            snapshot.data![0]['startLocation']['latitude'],
                            snapshot.data![0]['startLocation']['longitude']),
                        zoom: 14.0,
                      ),
                      markers: {
                        Marker(
                            markerId: const MarkerId('location'),
                            position: LatLng(
                                snapshot.data![0]['startLocation']['latitude'],
                                snapshot.data![0]['startLocation']
                                    ['longitude']),
                            infoWindow: InfoWindow(
                              title:
                                  '${widget.user['first_name']} ${widget.user['last_name']}',
                              snippet: snapshot.data![0]['endLocation']
                                      ['timestamp'] +
                                  "\n ," +
                                  snapshot.data![0]['endLocation']['address'],
                            ),
                            icon:
                                _markerIcon ?? BitmapDescriptor.defaultMarker),
                      }),

                  // Draggable overlay
                  DraggableScrollableSheet(
                    initialChildSize: 0.4, // Initial size (40% of the screen)
                    minChildSize: 0.2, // Minimum size (20% of the screen)
                    maxChildSize: 0.8, // Maximum size (80% of the screen)
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.location_on,
                                    color: Colors.blue,
                                  ),
                                  title: Text(
                                    snapshot.data![index]['startLocation']
                                        ['address'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  subtitle: Text(
                                    snapshot.data![index]['duration'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                    size: 18,
                                  ),
                                  onTap: () {
                                    // Example action: Move the map camera to a new position
                                    // mapController.animateCamera(
                                    //   CameraUpdate.newLatLng(
                                    //     LatLng(
                                    //       snapshot.data![index]['startLocation']["latitude"] + index * 0.01,
                                    //       snapshot.data![index]['startLocation']["longitude"] + index * 0.01,
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
