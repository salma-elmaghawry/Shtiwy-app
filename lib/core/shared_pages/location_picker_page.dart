import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shtiwy/core/services/location_service.dart';
import 'package:http/http.dart' as http;

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final TextEditingController _searchController = TextEditingController();
  late GoogleMapController _mapController;
  LatLng? _selectedLatLng;
  String? _selectedAddress;
  List<Map<String, String>> _predictions = [];
  CameraPosition _initialCamera = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 2,
  );
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final pos = await LocationService.getCurrentPosition();
    if (pos != null) {
      setState(() {
        _initialCamera = CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 14,
        );
      });
    }
    setState(() => _loading = false);
  }

  Future<void> _onSearch(String input) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) return;
    final url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {'input': input, 'key': apiKey, 'types': 'geocode', 'language': 'en'},
    );
    final res = await http.get(url);
    if (res.statusCode != 200) return;
    final data = json.decode(res.body) as Map<String, dynamic>;
    final preds = data['predictions'] as List<dynamic>? ?? [];
    setState(() {
      _predictions = preds
          .map(
            (p) => {
              'description': p['description'] as String,
              'place_id': p['place_id'] as String,
            },
          )
          .toList();
    });
  }

  Future<void> _selectPrediction(String placeId, String description) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) return;
    final url = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      {
        'place_id': placeId,
        'key': apiKey,
        'fields': 'geometry,formatted_address',
      },
    );
    final res = await http.get(url);
    if (res.statusCode != 200) return;
    final data = json.decode(res.body) as Map<String, dynamic>;
    final result = data['result'] as Map<String, dynamic>?;
    if (result == null) return;
    final loc = result['geometry']?['location'];
    if (loc == null) return;
    final lat = (loc['lat'] as num).toDouble();
    final lng = (loc['lng'] as num).toDouble();
    final address = result['formatted_address'] as String? ?? description;

    setState(() {
      _selectedLatLng = LatLng(lat, lng);
      _selectedAddress = address;
      _predictions = [];
      _searchController.text = address;
    });

    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_selectedLatLng!, 15),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('auth.signup.location_label'.tr()),
        actions: [
          TextButton(
            onPressed: _selectedLatLng == null
                ? null
                : () {
                    Navigator.of(context).pop({
                      'latitude': _selectedLatLng!.latitude,
                      'longitude': _selectedLatLng!.longitude,
                      'address': _selectedAddress,
                    });
                  },
            child: Text(
              'auth.signup.location_select_button'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'auth.signup.location_search_placeholder'.tr(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () =>
                            _onSearch(_searchController.text.trim()),
                      ),
                    ),
                    onSubmitted: _onSearch,
                  ),
                ),
                if (_predictions.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _predictions.length,
                      itemBuilder: (context, index) {
                        final p = _predictions[index];
                        return ListTile(
                          title: Text(p['description']!),
                          onTap: () => _selectPrediction(
                            p['place_id']!,
                            p['description']!,
                          ),
                        );
                      },
                    ),
                  )
                else
                  Expanded(
                    child: Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: _initialCamera,
                          onMapCreated: _onMapCreated,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          markers: _selectedLatLng == null
                              ? {}
                              : {
                                  Marker(
                                    markerId: const MarkerId('selected'),
                                    position: _selectedLatLng!,
                                  ),
                                },
                          onTap: (latlng) {
                            setState(() {
                              _selectedLatLng = latlng;
                              _selectedAddress = null;
                            });
                          },
                        ),
                        if (_selectedAddress != null)
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(_selectedAddress!),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}
