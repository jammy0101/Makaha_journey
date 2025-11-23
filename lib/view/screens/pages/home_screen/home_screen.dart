
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
import '../../../../resources/drawar/custom_drawar.dart';
import '../../../../resources/colors/colors.dart';
import '../chat_home_screen/chat_home.dart';

class HomeScreen extends StatefulWidget {
  final double? lat;
  final double? lng;

  const HomeScreen({Key? key, this.lat, this.lng}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _currentPosition;
  StreamSubscription<Position>? _positionStream;

  // ────────────── Coordinates & bounds ──────────────
  static const LatLng makkahCenter = LatLng(21.4225, 39.8262);
  static const LatLng madinahCenter = LatLng(24.4672, 39.6111);

  static final LatLngBounds makkahBounds = LatLngBounds(
    southwest: const LatLng(21.35, 39.80),
    northeast: const LatLng(21.45, 39.92),
  );

  static final LatLngBounds madinahBounds = LatLngBounds(
    southwest: const LatLng(24.44, 39.55),
    northeast: const LatLng(24.50, 39.70),
  );

  LatLngBounds? _activeBounds;
  bool isMakkah = true;

  // ────────────── Map Style ──────────────
  final String _mapStyle = '''[
    {"elementType":"geometry","stylers":[{"color":"#f9f7f1"}]},
    {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e6e0c0"}]},
    {"featureType":"poi.place_of_worship","elementType":"geometry","stylers":[{"color":"#f1e5d1"}]},
    {"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#d6e9f9"}]},
    {"elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]},
    {"elementType":"labels.text.stroke","stylers":[{"visibility":"off"}]}
  ]''';

  // ────────────── Landmarks ──────────────
  // We store base data here, but will build markers with onTap in _buildMarkers()
  final List<Map<String, dynamic>> _landmarkData = [
    {
      'id': 'kaaba'.tr,
      'position': makkahCenter,
      'title': 'Kaaba (Masjid al-Haram)'.tr,
      'snippet': 'Perform Tawaf & Recite Talbiyah here.'.tr,
    },
    {
      'id': 'safa_marwa'.tr,
      'position': const LatLng(21.4235, 39.8265),
      'title': 'Safa & Marwa'.tr,
      'snippet': 'Perform Sa’i between these two blessed hills.'.tr,
    },
    //here
    {
      'id': 'masjid_al_haram_gate_1'.tr,
      'position': const LatLng(21.4230, 39.8250),
      'title': 'Masjid al-Haram Gate 1'.tr,
      'snippet': 'Main entry gate'.tr,
    },
    {
      'id': 'masjid_al_haram_gate_2'.tr,
      'position': const LatLng(21.4215, 39.8275),
      'title': 'Masjid al-Haram Gate 2'.tr,
      'snippet': 'Secondary entry gate'.tr,
    },
    {
      'id': 'mina_tents'.tr,
      'position': const LatLng(21.4220, 39.9000),
      'title': 'Mina Tents'.tr,
      'snippet': 'Pilgrims accommodation area'.tr,
    },
    {
      'id': 'arafat'.tr,
      'position': const LatLng(21.3590, 39.9800),
      'title': 'Mount Arafat'.tr,
      'snippet': 'Place of Wuquf during Hajj'.tr,
    },
    {
      'id': 'jamaraat'.tr,
      'position': const LatLng(21.4190, 39.9050),
      'title': 'Jamarat'.tr,
      'snippet': 'Stoning of the devil'.tr,
    },
    // Madinah
    {
      'id': 'masjid_nabawi'.tr,
      'position': madinahCenter,
      'title': 'Masjid an-Nabawi'.tr,
      'snippet': 'Visit Rawdah and offer Salam to Prophet ﷺ.'.tr,
    },
    {
      'id': 'masjid_quba'.tr,
      'position': const LatLng(24.4677, 39.6143),
      'title': 'Masjid Quba'.tr,
      'snippet': 'First mosque in Islam. Offer 2 rakats here.'.tr,
    },
    {
      'id': 'masjid_qiblatain'.tr,
      'position': const LatLng(24.4725, 39.6150),
      'title': 'Masjid Qiblatain'.tr,
      'snippet': 'Mosque with two Qiblas.'.tr,
    },
  ];

  // mapping landmark id -> public image url (Wikimedia commons or other public images)
  // You can replace these URLs with your preferred images or with Google Image API results.
  final Map<String, String> _imageUrls = {
    'kaaba':
    'https://upload.wikimedia.org/wikipedia/commons/6/6f/Kaaba_Masjid_al-Haram.jpg',
    'safa_marwa':
    'https://upload.wikimedia.org/wikipedia/commons/1/15/Al_Safa.jpg',
    'masjid_al_haram_gate_1':
    'https://upload.wikimedia.org/wikipedia/commons/5/5f/Masjid_al-Haram_gate.jpg',
    'masjid_al_haram_gate_2':
    'https://upload.wikimedia.org/wikipedia/commons/2/2a/Masjid_al-Haram_entrance.jpg',
    'mina_tents':
    'https://upload.wikimedia.org/wikipedia/commons/8/88/Mina_tents.jpg',
    'arafat':
    'https://upload.wikimedia.org/wikipedia/commons/2/21/Mount_Arafat.jpg',
    'jamaraat':
    'https://upload.wikimedia.org/wikipedia/commons/4/4b/Jamarat_Mina.jpg',
    'masjid_nabawi':
    'https://upload.wikimedia.org/wikipedia/commons/4/44/Masjid_an-Nabawi.jpg',
    'masjid_quba':
    'https://upload.wikimedia.org/wikipedia/commons/f/f8/Masjid_Quba.jpg',
    'masjid_qiblatain':
    'https://upload.wikimedia.org/wikipedia/commons/0/09/Masjid_Qiblatain.jpg',
  };

  // Fallback local file path (developer: use uploaded file path)
  // This path comes from your uploaded file in the session.
  final String _localFallbackImage =
      '/mnt/data/Screenshot 2025-11-22 at 8.36.12 PM.png';

  late final List<LatLng> _tawafPath;
  Set<Polyline> _polylines = {};
  Set<Circle> _userCircle = {};

  Marker? _selectedMarker; // the tapped marker (we show bottom sheet for this)
  String? _selectedMarkerId;

  static const double _tawafRadius = 0.0008;

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
      return LatLng(
        makkahCenter.latitude + _tawafRadius * math.cos(angle),
        makkahCenter.longitude + _tawafRadius * math.sin(angle),
      );
    });
  }

  void _initPolylines() {
    _polylines = {
      Polyline(
        polylineId:  PolylineId('Tawaf'.tr),
        color: AppColor.gold,
        width: 6,
        points: _tawafPath,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };
  }

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

      // Listen to continuous updates
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
    if (!mounted) return;
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
  }

  Future<void> _switchCity(bool toMakkah) async {
    final controller = await _mapController.future;
    if (!mounted) return;
    setState(() {
      isMakkah = toMakkah;
      _activeBounds = toMakkah ? makkahBounds : madinahBounds;
    });
    controller.animateCamera(CameraUpdate.newLatLngBounds(_activeBounds!, 50));
  }

  Set<Marker> _buildMarkers() {
    final Set<Marker> markers = {};

    for (var item in _landmarkData) {
      final id = item['id'] as String;
      final LatLng pos = item['position'] as LatLng;
      final title = item['title'] as String;
      final snippet = item['snippet'] as String;

      markers.add(Marker(
        markerId: MarkerId(id),
        position: pos,
        infoWindow: InfoWindow(title: title, snippet: snippet),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
        onTap: () {
          // set the selected marker and open bottom sheet
          setState(() {
            _selectedMarkerId = id;
            _selectedMarker = Marker(
              markerId: MarkerId(id),
              position: pos,
              infoWindow: InfoWindow(title: title, snippet: snippet),
            );
          });
        },
      ));
    }

    // add 'me' marker if we have current position
    if (_currentPosition != null) {
      markers.add(Marker(
        markerId: const MarkerId('me'),
        position: _currentPosition!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ));
    }

    return markers;
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  // Build the draggable bottom card shown when a marker is tapped
  Widget _buildBottomCard() {
    if (_selectedMarkerId == null) return const SizedBox.shrink();

    final landmark = _landmarkData.firstWhere((l) => l['id'] == _selectedMarkerId);
    final title = landmark['title'] as String;
    final snippet = landmark['snippet'] as String;
    final imageUrl = _imageUrls[_selectedMarkerId] ??
        ''; // empty if we don't have a mapping

    return DraggableScrollableSheet(
      initialChildSize: 0.28,
      minChildSize: 0.10,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12)],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              // small handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // rounded image (network with fallback to local file)
                  Container(
                    width: 110,
                    height: 80,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
                    ),
                    child: InkWell(
                      onTap: () {
                        // open full screen preview
                        if (imageUrl.isNotEmpty) {
                          Get.to(() => _FullImagePreview(imageUrl: imageUrl, localFallback: _localFallbackImage));
                        } else {
                          Get.to(() => _FullImagePreview(imageUrl: '', localFallback: _localFallbackImage));
                        }
                      },
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) {
                          // network failed -> fallback to local file
                          final file = File(_localFallbackImage);
                          if (file.existsSync()) {
                            return Image.file(file, fit: BoxFit.cover);
                          }
                          // final fallback UI
                          return Container(
                            color: Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: Icon(Icons.photo, size: 40, color: Colors.grey.shade500),
                          );
                        },
                      )
                          : File(_localFallbackImage).existsSync()
                          ? Image.file(File(_localFallbackImage), fit: BoxFit.cover)
                          : Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: Icon(Icons.photo, size: 40, color: Colors.grey.shade500),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // title & snippet
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.deepCharcoal)),
                        const SizedBox(height: 6),
                        Text(snippet, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _switchCity(!isMakkah),
                      icon: const Icon(Icons.location_city_rounded),
                      label: Text(isMakkah ? 'Go to Madinah'.tr : 'Go to Makkah'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.gold,
                        foregroundColor: AppColor.deepCharcoal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // share: navigate to ChatsHomeScreen with args (lat, lng, title, image)
                        final pos = (landmark['position'] as LatLng);
                        Get.to(() => ChatsHomeScreen(), arguments: {
                          "lat": pos.latitude,
                          "lng": pos.longitude,
                          "title": title,
                          "imageUrl": imageUrl,
                        });
                      },
                      icon: const Icon(Icons.share_location_rounded),
                      label:  Text("Share".tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // extra actions row (example: open external maps, get directions, close)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        // Smoothly animate camera to the selected landmark
                        final controller = await _mapController.future;
                        final pos = (landmark['position'] as LatLng);
                        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 17)));
                      },
                      icon: const Icon(Icons.map_outlined),
                      //working... here
                      label:  Text('Focus'.tr),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // close bottom card
                        setState(() {
                          _selectedMarkerId = null;
                        });
                      },
                      icon: const Icon(Icons.close),
                      label:  Text('Close'.tr),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final markers = _buildMarkers();

    return Scaffold(
      drawer: const CustomDrawer(),
      bottomNavigationBar: const BottomNavigation(index: 0),
      appBar: AppBar(
        title: Text(
          isMakkah ? 'Makkah Journey'.tr : 'Madinah Journey'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 0.5),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: AppColor.gold,
        foregroundColor: AppColor.deepCharcoal,
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.satellite,
            initialCameraPosition: const CameraPosition(target: makkahCenter, zoom: 15),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: markers,
            polylines: _polylines,
            circles: _userCircle,
            cameraTargetBounds: CameraTargetBounds(_activeBounds),
            minMaxZoomPreference: const MinMaxZoomPreference(12, 18),
            onTap: (_) {
              // tapping outside markers closes bottom card
              setState(() {
                _selectedMarkerId = null;
              });
            },
            onMapCreated: (controller) async {
              _mapController.complete(controller);
              controller.setMapStyle(_mapStyle);
              controller.animateCamera( CameraUpdate.newCameraPosition(CameraPosition(target: makkahCenter, zoom: 16)));
            },
          ),

          // bottom card only when a marker is selected
          if (_selectedMarkerId != null) _buildBottomCard(),
        ],
      ),
    );
  }
}

// Simple full-screen image preview route
class _FullImagePreview extends StatelessWidget {
  final String imageUrl;
  final String localFallback;

  const _FullImagePreview({Key? key, required this.imageUrl, required this.localFallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final file = File(localFallback);
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColor.emeraldGreen, title:  Text('Preview'.tr)),
      body: Center(
        child: imageUrl.isNotEmpty
            ? Image.network(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) {
            if (file.existsSync()) {
              return Image.file(file, fit: BoxFit.contain);
            } else {
              return const Icon(Icons.broken_image, size: 80);
            }
          },
        )
            : file.existsSync()
            ? Image.file(file, fit: BoxFit.contain)
            : const Icon(Icons.broken_image, size: 80),
      ),
    );
  }
}
