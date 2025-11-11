//
// import 'dart:async';
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
// import '../../../../resources/drawar/custom_drawar.dart';
// import '../../../../resources/colors/colors.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final Completer<GoogleMapController> _controller = Completer();
//   LatLng? _currentPosition;
//
//   // ───────────────────────────────
//   // 🌍 Coordinates
//   // ───────────────────────────────
//   final LatLng makkahCenter = const LatLng(21.4225, 39.8262);
//   final LatLng madinahCenter = const LatLng(24.4672, 39.6111);
//
//   final LatLngBounds makkahBounds =  LatLngBounds(
//     southwest: LatLng(21.35, 39.80),
//     northeast: LatLng(21.45, 39.92),
//   );
//
//   final LatLngBounds madinahBounds =  LatLngBounds(
//     southwest: LatLng(24.44, 39.55),
//     northeast: LatLng(24.50, 39.70),
//   );
//
//   LatLngBounds? _activeBounds;
//   bool isMakkah = true;
//
//   // ───────────────────────────────
//   // 🗺 Map Style
//   // ───────────────────────────────
//   final String _mapStyle = '''[
//     {"elementType":"geometry","stylers":[{"color":"#f9f7f1"}]},
//     {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e6e0c0"}]},
//     {"featureType":"poi.place_of_worship","elementType":"geometry","stylers":[{"color":"#f1e5d1"}]},
//     {"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#d6e9f9"}]},
//     {"elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]},
//     {"elementType":"labels.text.stroke","stylers":[{"visibility":"off"}]}
//   ]''';
//
//   // ───────────────────────────────
//   // 🕌 Landmarks
//   // ───────────────────────────────
//   final Set<Marker> _landmarks = {
//     Marker(
//       markerId: MarkerId('kaaba'),
//       position: LatLng(21.4225, 39.8262),
//       infoWindow: InfoWindow(
//         title: 'Kaaba (Masjid al-Haram)',
//         snippet: 'Perform Tawaf & Recite Talbiyah here.',
//       ),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
//     ),
//     Marker(
//       markerId: MarkerId('safa_marwa'),
//       position: LatLng(21.4235, 39.8265),
//       infoWindow: InfoWindow(
//         title: 'Safa & Marwa',
//         snippet: 'Perform Sa’i between these two blessed hills.',
//       ),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
//     ),
//     Marker(
//       markerId: MarkerId('masjid_nabawi'),
//       position: LatLng(24.4672, 39.6111),
//       infoWindow: InfoWindow(
//         title: 'Masjid an-Nabawi',
//         snippet: 'Visit Rawdah and offer Salam to Prophet ﷺ.',
//       ),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//     ),
//     Marker(
//       markerId: MarkerId('masjid_quba'),
//       position: LatLng(24.4677, 39.6143),
//       infoWindow: InfoWindow(
//         title: 'Masjid Quba',
//         snippet: 'First mosque in Islam. Offer 2 rakats here.',
//       ),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
//     ),
//   };
//
//   // 🕋 Circular Tawaf Path
//   late final List<LatLng> _tawafPath;
//   Set<Polyline> _polylines = {};
//   Set<Circle> _userCircle = {};
//   Marker? _nearestLandmark;
//
//   @override
//   void initState() {
//     super.initState();
//     _activeBounds = makkahBounds;
//     _generateTawafPath();
//     _initPolylines();
//     _getUserLocation();
//   }
//
//   void _generateTawafPath() {
//     _tawafPath = List.generate(360, (i) {
//       final angle = i * math.pi / 180;
//       const radius = 0.0008;
//       return LatLng(
//         21.4225 + radius * math.cos(angle),
//         39.8262 + radius * math.sin(angle),
//       );
//     });
//   }
//
//   void _initPolylines() {
//     _polylines = {
//       Polyline(
//         polylineId: const PolylineId('tawaf'),
//         color: AppColor.gold,
//         width: 6,
//         points: _tawafPath,
//         startCap: Cap.roundCap,
//         endCap: Cap.roundCap,
//       ),
//     };
//   }
//
//   // 📍 User Location
//   Future<void> _getUserLocation() async {
//     if (!await Geolocator.isLocationServiceEnabled()) return;
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//     }
//
//     try {
//       final pos = await Geolocator.getCurrentPosition();
//       _updateUserPosition(LatLng(pos.latitude, pos.longitude));
//
//       final controller = await _controller.future;
//       controller.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 16));
//
//       Geolocator.getPositionStream(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.bestForNavigation,
//           distanceFilter: 3,
//         ),
//       ).listen((position) {
//         _updateUserPosition(LatLng(position.latitude, position.longitude));
//       });
//     } catch (e) {
//       debugPrint("Error getting location: $e");
//     }
//   }
//
//   void _updateUserPosition(LatLng position) {
//     setState(() {
//       _currentPosition = position;
//       _userCircle = {
//         Circle(
//           circleId: const CircleId('user'),
//           center: position,
//           radius: 6,
//           fillColor: Colors.blueAccent.withOpacity(0.5),
//           strokeColor: Colors.blueAccent,
//           strokeWidth: 2,
//         ),
//       };
//     });
//     _findNearestLandmark(position);
//   }
//
//   // 🧭 Find Nearest Landmark
//   void _findNearestLandmark(LatLng userPos) {
//     double minDist = double.infinity;
//     Marker? nearest;
//     for (var landmark in _landmarks) {
//       double dist = _distance(userPos, landmark.position);
//       if (dist < minDist) {
//         minDist = dist;
//         nearest = landmark;
//       }
//     }
//     setState(() => _nearestLandmark = nearest);
//   }
//
//   double _distance(LatLng a, LatLng b) {
//     const R = 6371000;
//     double dLat = _toRad(b.latitude - a.latitude);
//     double dLon = _toRad(b.longitude - a.longitude);
//     double lat1 = _toRad(a.latitude);
//     double lat2 = _toRad(b.latitude);
//     double h = math.sin(dLat / 2) * math.sin(dLat / 2) +
//         math.cos(lat1) * math.cos(lat2) *
//             math.sin(dLon / 2) * math.sin(dLon / 2);
//     double c = 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
//     return R * c;
//   }
//
//   double _toRad(double deg) => deg * (math.pi / 180);
//
//   // 🔄 Switch City
//   void _switchCity(bool toMakkah) async {
//     final controller = await _controller.future;
//     setState(() {
//       isMakkah = toMakkah;
//       _activeBounds = toMakkah ? makkahBounds : madinahBounds;
//     });
//     controller.animateCamera(CameraUpdate.newLatLngBounds(_activeBounds!, 50));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const CustomDrawer(),
//       bottomNavigationBar: const BottomNavigation(index: 0),
//       appBar: AppBar(
//         title: Text(
//           isMakkah ? 'Makkah Journey' : 'Madinah Journey',
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             letterSpacing: 0.5,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 2,
//         backgroundColor: AppColor.gold,
//         foregroundColor: AppColor.deepCharcoal,
//       ),
//
//       body: Stack(
//         children: [
//           // 🗺 Map
//           GoogleMap(
//             initialCameraPosition: CameraPosition(target: makkahCenter, zoom: 15),
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             markers: {
//               ..._landmarks,
//               if (_currentPosition != null)
//                 Marker(
//                   markerId: const MarkerId('me'),
//                   position: _currentPosition!,
//                   icon: BitmapDescriptor.defaultMarkerWithHue(
//                     BitmapDescriptor.hueAzure,
//                   ),
//                 ),
//             },
//             polylines: _polylines,
//             circles: _userCircle,
//             cameraTargetBounds: CameraTargetBounds(_activeBounds),
//             minMaxZoomPreference: const MinMaxZoomPreference(12, 18),
//             onMapCreated: (controller) {
//               _controller.complete(controller);
//               controller.setMapStyle(_mapStyle);
//             },
//           ),
//
//           // 🕌 Bottom Info Card
//           if (_nearestLandmark != null)
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 350),
//                 curve: Curves.easeOutCubic,
//                 padding: const EdgeInsets.all(16),
//                 margin: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(18),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 10,
//                       offset: const Offset(0, -3),
//                     ),
//                   ],
//                 ),
//                 height: 170,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       _nearestLandmark!.infoWindow.title ?? '',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: AppColor.deepCharcoal,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       _nearestLandmark!.infoWindow.snippet ?? '',
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.black87,
//                         height: 1.4,
//                       ),
//                     ),
//                     const Spacer(),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             onPressed: () => _switchCity(!isMakkah),
//                             icon: const Icon(Icons.location_city_rounded),
//                             label: Text(isMakkah ? 'Go to Madinah' : 'Go to Makkah'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColor.gold,
//                               foregroundColor: AppColor.deepCharcoal,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             onPressed: () {
//                               Get.snackbar(
//                                 "Location Shared",
//                                 "Lat: ${_currentPosition?.latitude.toStringAsFixed(4)}, "
//                                     "Lng: ${_currentPosition?.longitude.toStringAsFixed(4)}",
//                                 backgroundColor: Colors.green,
//                                 colorText: Colors.white,
//                                 snackPosition: SnackPosition.BOTTOM,
//                               );
//                             },
//                             icon: const Icon(Icons.share_location_rounded),
//                             label: const Text("Share"),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.teal,
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
import '../../../../resources/drawar/custom_drawar.dart';
import '../../../../resources/colors/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;

  StreamSubscription<Position>? _positionStream; // 🟢 Track stream to cancel

  // ───────────────────────────────
  // 🌍 Coordinates
  // ───────────────────────────────
  final LatLng makkahCenter = const LatLng(21.4225, 39.8262);
  final LatLng madinahCenter = const LatLng(24.4672, 39.6111);

  final LatLngBounds makkahBounds = LatLngBounds(
    southwest: LatLng(21.35, 39.80),
    northeast: LatLng(21.45, 39.92),
  );

  final LatLngBounds madinahBounds = LatLngBounds(
    southwest: LatLng(24.44, 39.55),
    northeast: LatLng(24.50, 39.70),
  );

  LatLngBounds? _activeBounds;
  bool isMakkah = true;

  // ───────────────────────────────
  // 🗺 Map Style
  // ───────────────────────────────
  final String _mapStyle = '''[
    {"elementType":"geometry","stylers":[{"color":"#f9f7f1"}]},
    {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e6e0c0"}]},
    {"featureType":"poi.place_of_worship","elementType":"geometry","stylers":[{"color":"#f1e5d1"}]},
    {"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#d6e9f9"}]},
    {"elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]},
    {"elementType":"labels.text.stroke","stylers":[{"visibility":"off"}]}
  ]''';

  // ───────────────────────────────
  // 🕌 Landmarks
  // ───────────────────────────────
  final Set<Marker> _landmarks = {
    Marker(
      markerId: MarkerId('kaaba'),
      position: LatLng(21.4225, 39.8262),
      infoWindow: InfoWindow(
        title: 'Kaaba (Masjid al-Haram)',
        snippet: 'Perform Tawaf & Recite Talbiyah here.',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
    ),
    Marker(
      markerId: MarkerId('safa_marwa'),
      position: LatLng(21.4235, 39.8265),
      infoWindow: InfoWindow(
        title: 'Safa & Marwa',
        snippet: 'Perform Sa’i between these two blessed hills.',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    ),
    Marker(
      markerId: MarkerId('masjid_nabawi'),
      position: LatLng(24.4672, 39.6111),
      infoWindow: InfoWindow(
        title: 'Masjid an-Nabawi',
        snippet: 'Visit Rawdah and offer Salam to Prophet ﷺ.',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: MarkerId('masjid_quba'),
      position: LatLng(24.4677, 39.6143),
      infoWindow: InfoWindow(
        title: 'Masjid Quba',
        snippet: 'First mosque in Islam. Offer 2 rakats here.',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    ),
  };

  late final List<LatLng> _tawafPath;
  Set<Polyline> _polylines = {};
  Set<Circle> _userCircle = {};
  Marker? _nearestLandmark;

  @override
  void initState() {
    super.initState();
    _activeBounds = makkahBounds;
    _generateTawafPath();
    _initPolylines();
    _getUserLocation();
  }

  void _generateTawafPath() {
    _tawafPath = List.generate(360, (i) {
      final angle = i * math.pi / 180;
      const radius = 0.0008;
      return LatLng(
        21.4225 + radius * math.cos(angle),
        39.8262 + radius * math.sin(angle),
      );
    });
  }

  void _initPolylines() {
    _polylines = {
      Polyline(
        polylineId: const PolylineId('tawaf'),
        color: AppColor.gold,
        width: 6,
        points: _tawafPath,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };
  }

  // 📍 User Location
  Future<void> _getUserLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    try {
      final pos = await Geolocator.getCurrentPosition();
      _updateUserPosition(LatLng(pos.latitude, pos.longitude));

      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition!, 16));

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          distanceFilter: 3,
        ),
      ).listen((position) {
        _updateUserPosition(LatLng(position.latitude, position.longitude));
      });
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  void _updateUserPosition(LatLng position) {
    if (!mounted) return; // ✅ Check if widget still exists
    setState(() {
      _currentPosition = position;
      _userCircle = {
        Circle(
          circleId: const CircleId('user'),
          center: position,
          radius: 6,
          fillColor: Colors.blueAccent.withOpacity(0.5),
          strokeColor: Colors.blueAccent,
          strokeWidth: 2,
        ),
      };
    });
    _findNearestLandmark(position);
  }

  void _findNearestLandmark(LatLng userPos) {
    double minDist = double.infinity;
    Marker? nearest;
    for (var landmark in _landmarks) {
      double dist = _distance(userPos, landmark.position);
      if (dist < minDist) {
        minDist = dist;
        nearest = landmark;
      }
    }
    if (!mounted) return; // ✅ Prevent setState after dispose
    setState(() => _nearestLandmark = nearest);
  }

  double _distance(LatLng a, LatLng b) {
    const R = 6371000;
    double dLat = _toRad(b.latitude - a.latitude);
    double dLon = _toRad(b.longitude - a.longitude);
    double lat1 = _toRad(a.latitude);
    double lat2 = _toRad(b.latitude);
    double h = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
    return R * c;
  }

  double _toRad(double deg) => deg * (math.pi / 180);

  // 🔄 Switch City
  void _switchCity(bool toMakkah) async {
    final controller = await _controller.future;
    if (!mounted) return;
    setState(() {
      isMakkah = toMakkah;
      _activeBounds = toMakkah ? makkahBounds : madinahBounds;
    });
    controller.animateCamera(CameraUpdate.newLatLngBounds(_activeBounds!, 50));
  }

  @override
  void dispose() {
    _positionStream?.cancel(); // ✅ Cancel subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      bottomNavigationBar: const BottomNavigation(index: 0),
      appBar: AppBar(
        title: Text(
          isMakkah ? 'Makkah Journey' : 'Madinah Journey',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: AppColor.gold,
        foregroundColor: AppColor.deepCharcoal,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: makkahCenter, zoom: 15),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: {
              ..._landmarks,
              if (_currentPosition != null)
                Marker(
                  markerId: const MarkerId('me'),
                  position: _currentPosition!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                ),
            },
            polylines: _polylines,
            circles: _userCircle,
            cameraTargetBounds: CameraTargetBounds(_activeBounds),
            minMaxZoomPreference: const MinMaxZoomPreference(12, 18),
            onMapCreated: (controller) {
              _controller.complete(controller);
              controller.setMapStyle(_mapStyle);
            },
          ),
          if (_nearestLandmark != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                height: 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _nearestLandmark!.infoWindow.title ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.deepCharcoal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _nearestLandmark!.infoWindow.snippet ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _switchCity(!isMakkah),
                            icon: const Icon(Icons.location_city_rounded),
                            label: Text(isMakkah ? 'Go to Madinah' : 'Go to Makkah'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.gold,
                              foregroundColor: AppColor.deepCharcoal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (_currentPosition != null) {
                                Get.snackbar(
                                  "Location Shared",
                                  "Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}, "
                                      "Lng: ${_currentPosition!.longitude.toStringAsFixed(4)}",
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            },
                            icon: const Icon(Icons.share_location_rounded),
                            label: const Text("Share"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
