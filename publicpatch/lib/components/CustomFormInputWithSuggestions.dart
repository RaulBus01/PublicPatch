import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:publicpatch/models/LocationData.dart';
import 'package:publicpatch/utils/geolocationFunctions.dart';

class CustomFormInputSuggestions extends StatefulWidget {
  final String title;
  final bool obscureText;
  final IconData? preFixIcon;
  final IconData? suffixIcon;
  final TextEditingController controller;
  final Function(LocationData)? onLocationSelected;

  const CustomFormInputSuggestions({
    super.key,
    required this.title,
    required this.controller,
    this.obscureText = false,
    this.preFixIcon,
    this.suffixIcon,
    this.onLocationSelected,
  });

  @override
  State<CustomFormInputSuggestions> createState() => _CustomFormInputState();
}

class _CustomFormInputState extends State<CustomFormInputSuggestions> {
  late bool _obscureText;
  final _sessionToken = Uuid().v4();
  List<Map<String, dynamic>> _placeList = []; // Explicitly typed as Map
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    widget.controller.addListener(_onChanged);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _hideOverlay();
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged); // Clean up listener
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (widget.controller.text.length > 1) {
      getSuggestion(widget.controller.text);
    } else {
      _hideOverlay();
    }
  }

  Future<void> getSuggestion(String input) async {
    const String kplacesApiKey =
        'API_KEY'; // Replace with your API key
    const String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String request =
        '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$_sessionToken';

    try {
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> predictions = data['predictions'] ?? [];

        if (mounted) {
          setState(() {
            _placeList = predictions
                .map((prediction) => prediction as Map<String, dynamic>)
                .toList();
          });

          if (_placeList.isNotEmpty && _focusNode.hasFocus) {
            _showOverlay();
          } else {
            _hideOverlay();
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching suggestions: $e');
      _hideOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
    }

    _overlayEntry = _createOverlayEntry();
    if (mounted) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  Future<void> _selectPlace(int index) async {
    if (index < 0 || index >= _placeList.length) return;

    try {
      final selected = _placeList[index];
      debugPrint(selected.toString());
      final description = selected['description'] as String? ?? '';

      final decode =
          await GeocodingPlatform.instance?.locationFromAddress(description);

      debugPrint(decode?[0].latitude.toString());
      debugPrint(decode?[0].longitude.toString());

      widget.controller.text = description;
      if (widget.onLocationSelected != null) {
        widget.onLocationSelected!(LocationData(
          latitude: decode?[0].latitude ?? 0.0,
          longitude: decode?[0].longitude ?? 0.0,
          address: description,
        ));
      }

      _hideOverlay();
      _focusNode.unfocus();
    } catch (e) {
      debugPrint('Error selecting place: $e');
      _hideOverlay();
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _hideOverlay,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  elevation: 4.0,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _placeList.length,
                      itemBuilder: (context, index) {
                        final place = _placeList[index];
                        final description =
                            place['description'] as String? ?? '';

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _selectPlace(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            child: Text(
                              description,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: 251,
        height: 50,
        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            prefixIcon: widget.preFixIcon != null
                ? Icon(widget.preFixIcon, color: const Color(0xFF768196))
                : null,
            suffixIcon: widget.suffixIcon == Icons.my_location_outlined
                ? IconButton(
                    onPressed: () async {
                      try {
                        widget.controller.text = 'Getting location...';
                        Position position = await determinePosition();
                        String address = await determineAddress(position);
                        widget.controller.text = address;
                        if (widget.onLocationSelected != null) {
                          widget.onLocationSelected!(LocationData(
                            latitude: position.latitude,
                            longitude: position.longitude,
                            address: address,
                          ));
                        }
                      } catch (e) {
                        debugPrint('Error getting location: $e');
                        widget.controller.text = '';
                      }
                    },
                    icon:
                        Icon(widget.suffixIcon, color: const Color(0xFF768196)),
                  )
                : widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF768196),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null,
            hintText: widget.title,
            hintStyle: const TextStyle(color: Color(0xFF768196)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
          enableSuggestions: !widget.obscureText,
          obscureText: _obscureText,
          autocorrect: false,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
