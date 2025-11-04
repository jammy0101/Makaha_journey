//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:async';
// import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
// import '../../../../resources/drawar/custom_drawar.dart';
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
//   final LatLng makkah = const LatLng(21.3891, 39.8579);
//   final LatLng madinah = const LatLng(24.5247, 39.5692);
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//   }
//
//   Future<void> _getUserLocation() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return;
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//     }
//
//     final pos = await Geolocator.getCurrentPosition();
//     setState(() {
//       _currentPosition = LatLng(pos.latitude, pos.longitude);
//     });
//
//     final GoogleMapController mapController = await _controller.future;
//     mapController.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(target: _currentPosition!, zoom: 14),
//       ),
//     );
//   }
//
//   void _moveToMakkah() async {
//     final GoogleMapController mapController = await _controller.future;
//     mapController.animateCamera(CameraUpdate.newLatLngZoom(makkah, 13));
//   }
//
//   void _moveToMadinah() async {
//     final GoogleMapController mapController = await _controller.future;
//     mapController.animateCamera(CameraUpdate.newLatLngZoom(madinah, 13));
//   }
//
//   void _shareMyLocation() {
//     if (_currentPosition == null) return;
//     final lat = _currentPosition!.latitude;
//     final lng = _currentPosition!.longitude;
//     Get.snackbar(
//       "Location Shared",
//       "Lat: $lat, Lng: $lng",
//       backgroundColor: Colors.green.shade600,
//       colorText: Colors.white,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('HomeScreen'.tr),
//         centerTitle: true,
//       ),
//       drawer: const CustomDrawer(),
//       bottomNavigationBar: const BottomNavigation(index: 0),
//       body: Stack(
//         children: [
//           /// 🌍 Google Map centered between Makkah & Madinah
//           GoogleMap(
//             mapType: MapType.normal,
//             initialCameraPosition: CameraPosition(
//               target: LatLng(22.9, 39.7), // midpoint between Makkah & Madinah
//               zoom: 6.5, // zoomed out to show both cities
//             ),
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             markers: {
//               Marker(
//                 markerId: const MarkerId('makkah'),
//                 position: makkah,
//                 infoWindow: const InfoWindow(title: 'Makkah Al-Mukarramah'),
//               ),
//               Marker(
//                 markerId: const MarkerId('madinah'),
//                 position: madinah,
//                 infoWindow: const InfoWindow(title: 'Madinah Al-Munawwarah'),
//               ),
//               if (_currentPosition != null)
//                 Marker(
//                   markerId: const MarkerId('me'),
//                   position: _currentPosition!,
//                   infoWindow: const InfoWindow(title: 'My Location'),
//                   icon: BitmapDescriptor.defaultMarkerWithHue(
//                       BitmapDescriptor.hueAzure),
//                 ),
//             },
//             onMapCreated: (controller) => _controller.complete(controller),
//           ),
//
//           /// 🧭 Control buttons
//           Positioned(
//             bottom: 20,
//             right: 10,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 FloatingActionButton.extended(
//                   onPressed: _shareMyLocation,
//                   heroTag: 'share_location_fab', // ✅ unique tag
//                   label: const Text("Share My Location"),
//                   icon: const Icon(Icons.share_location),
//                 ),
//                 const SizedBox(height: 10),
//                 FloatingActionButton.extended(
//                   onPressed: _moveToMakkah,
//                   heroTag: 'makkah_fab', // ✅ unique tag
//                   label: const Text("Go to Makkah"),
//                   icon: const Icon(Icons.place),
//                 ),
//                 const SizedBox(height: 10),
//                 FloatingActionButton.extended(
//                   onPressed: _moveToMadinah,
//                   heroTag: 'madinah_fab', // ✅ unique tag
//                   label: const Text("Go to Madinah"),
//                   icon: const Icon(Icons.mosque),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
import '../../../../resources/drawar/custom_drawar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;

  final LatLng makkah = const LatLng(21.3891, 39.8579);
  final LatLng madinah = const LatLng(24.5247, 39.5692);

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  /// ✅ FIXED: added `if (!mounted) return;` before calling setState()
  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    try {
      final pos = await Geolocator.getCurrentPosition();

      // ✅ Ensure widget is still active before calling setState
      if (!mounted) return;
      setState(() {
        _currentPosition = LatLng(pos.latitude, pos.longitude);
      });

      final GoogleMapController mapController = await _controller.future;
      if (!mounted) return; // ✅ again, in case user navigates away
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 14),
        ),
      );
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  void _moveToMakkah() async {
    final GoogleMapController mapController = await _controller.future;
    mapController.animateCamera(CameraUpdate.newLatLngZoom(makkah, 13));
  }

  void _moveToMadinah() async {
    final GoogleMapController mapController = await _controller.future;
    mapController.animateCamera(CameraUpdate.newLatLngZoom(madinah, 13));
  }

  void _shareMyLocation() {
    if (_currentPosition == null) return;
    final lat = _currentPosition!.latitude;
    final lng = _currentPosition!.longitude;
    Get.snackbar(
      "Location Shared",
      "Lat: $lat, Lng: $lng",
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeScreen'.tr),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      bottomNavigationBar: const BottomNavigation(index: 0),
      body: Stack(
        children: [
          /// 🌍 Google Map centered between Makkah & Madinah
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(22.9, 39.7), // midpoint between Makkah & Madinah
              zoom: 6.5, // zoomed out to show both cities
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: {
              Marker(
                markerId: const MarkerId('makkah'),
                position: makkah,
                infoWindow: const InfoWindow(title: 'Makkah Al-Mukarramah'),
              ),
              Marker(
                markerId: const MarkerId('madinah'),
                position: madinah,
                infoWindow: const InfoWindow(title: 'Madinah Al-Munawwarah'),
              ),
              if (_currentPosition != null)
                Marker(
                  markerId: const MarkerId('me'),
                  position: _currentPosition!,
                  infoWindow: const InfoWindow(title: 'My Location'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                ),
            },
            onMapCreated: (controller) => _controller.complete(controller),
          ),

          /// 🧭 Floating action buttons
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  onPressed: _shareMyLocation,
                  heroTag: 'share_location_fab',
                  label: const Text("Share My Location"),
                  icon: const Icon(Icons.share_location),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  onPressed: _moveToMakkah,
                  heroTag: 'makkah_fab',
                  label: const Text("Go to Makkah"),
                  icon: const Icon(Icons.place),
                ),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  onPressed: _moveToMadinah,
                  heroTag: 'madinah_fab',
                  label: const Text("Go to Madinah"),
                  icon: const Icon(Icons.mosque),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
