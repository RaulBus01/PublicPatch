import 'dart:convert';
import 'package:flutter/material.dart';
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
  List<dynamic> _placeList = [];
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
    _hideOverlay();
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
    const String kplacesApiKey = 'API_KEY';
    const String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    final String request =
        '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$_sessionToken';

    try {
      final response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        final predictions = json.decode(response.body)['predictions'];
        if (mounted) {
          setState(() {
            _placeList = predictions;
          });
          if (predictions.isNotEmpty && _focusNode.hasFocus) {
            _showOverlay();
          } else {
            _hideOverlay();
          }
        }
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
    }
  }

  void _showOverlay() {
    if (!mounted) return; // Check if the widget is still mounted
    _overlayEntry?.remove();
    _overlayEntry = _createOverlayEntry();
    if (mounted) {
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _placeList = [];
      });
    }
  }

  void _selectPlace(int index) {
    final selected = _placeList[index];
    _hideOverlay();
    widget.controller.text = selected['description'];
    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(LocationData(
        latitude: 0,
        longitude: 0,
        address: selected['description'],
      ));
    }
    _focusNode.unfocus();
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
                    constraints: BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _placeList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _selectPlace(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 12.0,
                            ),
                            child: Text(
                              _placeList[index]['description'],
                              style: TextStyle(
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
                ? Icon(widget.preFixIcon, color: Color(0xFF768196))
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
                        print(e);
                      }
                    },
                    icon: Icon(widget.suffixIcon, color: Color(0xFF768196)),
                  )
                : widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xFF768196),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null,
            hintText: widget.title,
            hintStyle: TextStyle(color: Color(0xFF768196)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
          enableSuggestions: widget.obscureText ? false : true,
          obscureText: _obscureText,
          autocorrect: false,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
