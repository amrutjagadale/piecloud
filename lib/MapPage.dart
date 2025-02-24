import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  BitmapDescriptor? _cameraIcon;

  static const LatLng _center = LatLng(18.5204, 73.8567);
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: _center,
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
  }

  Future<void> _loadCustomMarker() async {
    final BitmapDescriptor customIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(70, 70)),
      'assets/images/camera_icon.png',
    );

    setState(() {
      _cameraIcon = customIcon;
    });
    _addDefaultMarkers();
  }

  void _addDefaultMarkers() {
    if (_cameraIcon == null) return;

    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('center_marker'),
          position: _center,
          icon: _cameraIcon!,
          infoWindow: const InfoWindow(
            title: 'Center Location',
            snippet: 'This is the center marker',
          ),
        ),
      );
    });
  }

  void _refreshMarkers() async {
    setState(() {
      _markers.clear();
    });

    if (_controller != null) {
      await _controller!.animateCamera(
        CameraUpdate.newCameraPosition(_initialCameraPosition),
      );
    }

    _addDefaultMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Page'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            zoomControlsEnabled: false,
          ),
          Positioned(
            right: 16,
            bottom: 20,
            child: Column(
              children: [
                FloatingActionButton.small(
                  onPressed: () {
                    _controller?.animateCamera(CameraUpdate.zoomIn());
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  onPressed: () {
                    _controller?.animateCamera(CameraUpdate.zoomOut());
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
          // New: Positioned refresh button with padding
          Positioned(
            left: 16,
            bottom: 32, // Increased bottom padding
            child: FloatingActionButton(
              onPressed: _refreshMarkers,
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }
}