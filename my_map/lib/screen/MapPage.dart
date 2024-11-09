import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:my_map/screen/state/MapPageState.dart';

class MapPage extends StatefulWidget {
  final dynamic user;
  const MapPage({Key? key, required this.user}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}
