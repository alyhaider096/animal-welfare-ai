import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Location _location = Location();
  LatLng? _myPos;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      if (!await _location.serviceEnabled()) {
        final ok = await _location.requestService();
        if (!ok) {
          setState(() => _loading = false);
          return;
        }
      }

      var perm = await _location.hasPermission();
      if (perm == PermissionStatus.denied) {
        perm = await _location.requestPermission();
      }

      if (perm == PermissionStatus.granted ||
          perm == PermissionStatus.grantedLimited) {
        final loc = await _location.getLocation();
        if (loc.latitude != null && loc.longitude != null) {
          _myPos = LatLng(loc.latitude!, loc.longitude!);
        }
      }
    } catch (_) {}

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initialCenter = _myPos ?? const LatLng(33.6844, 73.0479);

    return Scaffold(
      appBar: AppBar(title: const Text("Live Map 🐾")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cases')
                  .snapshots(),
              builder: (context, snap) {
                final docs = snap.data?.docs ?? [];

                final markers = <Marker>[
                  if (_myPos != null)
                    Marker(
                      width: 46,
                      height: 46,
                      point: _myPos!,
                      child: Icon(
                        Icons.my_location,
                        color: theme.colorScheme.primary,
                        size: 28,
                      ),
                    ),
                  ...docs.map((d) {
                    final data = d.data() as Map<String, dynamic>;
                    final lat = (data['latitude'] as num?)?.toDouble();
                    final lng = (data['longitude'] as num?)?.toDouble();
                    final desc = (data['description'] ?? '').toString();
                    final imageUrl = (data['imageUrl'] ?? '').toString();

                    if (lat == null || lng == null) return null;

                    return Marker(
                      width: 52,
                      height: 52,
                      point: LatLng(lat, lng),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            showDragHandle: true,
                            builder: (_) => Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Reported Animal 🐾",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  if (imageUrl.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        imageUrl,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(height: 12),
                                  Text(
                                    desc.isEmpty
                                        ? "No description provided."
                                        : desc,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.pets,
                          color: Colors.redAccent,
                          size: 34,
                        ),
                      ),
                    );
                  }).whereType<Marker>(),
                ];

                return FlutterMap(
                  options: MapOptions(
                    initialCenter: initialCenter,
                    initialZoom: 13,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: 'com.example.animlawelfare',
                    ),
                    MarkerLayer(markers: markers),
                  ],
                );
              },
            ),
    );
  }
}
