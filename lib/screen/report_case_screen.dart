import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../model/case_model.dart';
import '../service/firestore_service.dart';
import '../service/storage_service.dart';

class ReportCaseScreen extends StatefulWidget {
  const ReportCaseScreen({super.key});

  @override
  State<ReportCaseScreen> createState() => _ReportCaseScreenState();
}

class _ReportCaseScreenState extends State<ReportCaseScreen>
    with SingleTickerProviderStateMixin {
  final _picker = ImagePicker();
  final _firestore = FirestoreService();
  final _storage = StorageService();
  final _loc = Location();

  final _descCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  File? _image;
  LatLng? _pos;
  bool _loading = false;

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slide = Tween(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _getLocation() async {
    if (!await _loc.serviceEnabled()) {
      if (!await _loc.requestService()) return;
    }

    var perm = await _loc.hasPermission();
    if (perm == PermissionStatus.denied) {
      perm = await _loc.requestPermission();
    }
    if (perm != PermissionStatus.granted &&
        perm != PermissionStatus.grantedLimited)
      return;

    final data = await _loc.getLocation();
    if (data.latitude != null && data.longitude != null) {
      setState(() {
        _pos = LatLng(data.latitude!, data.longitude!);
      });
    }
  }

  Future<void> _submit() async {
    if (_image == null ||
        _pos == null ||
        _descCtrl.text.trim().isEmpty ||
        _nameCtrl.text.trim().isEmpty ||
        _phoneCtrl.text.trim().isEmpty) {
      _toast("Please complete all fields");
      return;
    }

    setState(() => _loading = true);

    try {
      final imageUrl = await _storage.uploadImage(
        _image!,
        'cases/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final caseData = CaseModel(
        caseId: DateTime.now().millisecondsSinceEpoch.toString(),
        imageUrl: imageUrl,
        description: _descCtrl.text.trim(),
        latitude: _pos!.latitude,
        longitude: _pos!.longitude,
        reporterName: _nameCtrl.text.trim(),
        reporterPhone: _phoneCtrl.text.trim(),
        reporterType: "user",
        status: "pending",
        urgentLevel: "normal",
        createdAt: DateTime.now(),
      );

      await _firestore.addCase(caseData);

      if (mounted) {
        _toast("Case submitted successfully 🐾");
        Navigator.pop(context);
      }
    } catch (e) {
      _toast("Submit failed: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Animal Case")),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 190,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: _image == null
                            ? const Center(child: Text("Tap to add photo 📸"))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.file(_image!, fit: BoxFit.cover),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _descCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: "Your Name"),
                    ),
                    const SizedBox(height: 10),

                    TextField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Contact Number",
                      ),
                    ),
                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      onPressed: _getLocation,
                      icon: const Icon(Icons.my_location),
                      label: Text(
                        _pos == null ? "Get Location" : "Location Added ✅",
                      ),
                    ),

                    if (_pos != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: SizedBox(
                          height: 200,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: _pos!,
                              initialZoom: 16,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: _pos!,
                                    child: const Icon(
                                      Icons.pets,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Submit Case 🐾"),
                    ),
                  ],
                ),
              ),
              if (_loading) const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
