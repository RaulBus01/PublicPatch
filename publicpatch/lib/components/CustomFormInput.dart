import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:publicpatch/models/LocationData.dart';
import 'package:publicpatch/utils/geolocationFunctions.dart';
import 'package:uuid/uuid.dart';

class CustomFormInput extends StatefulWidget {
  final String title;
  final bool obscureText;
  final IconData? preFixIcon;
  final IconData? suffixIcon;
  final TextEditingController controller;
  final Function(LocationData)? onLocationSelected;
  final String? content;
  const CustomFormInput({
    super.key,
    required this.title,
    required this.controller,
    this.obscureText = false,
    this.preFixIcon,
    this.suffixIcon,
    this.onLocationSelected,
    this.content,
  });

  @override
  State<CustomFormInput> createState() => _CustomFormInputState();
}

class _CustomFormInputState extends State<CustomFormInput> {
  late bool _obscureText;
  final _controller = TextEditingController();
  var uuid = Uuid();
  final String _sessionToken = Uuid().toString();
  List<dynamic> _placeList = [];
  @override
  void getSuggestion(String input) async {
    String kplacesApiKey = 'API_KEY';
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  void _onChanged() {
    getSuggestion(_controller.text);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (widget.content != null) {
        _controller.text = widget.content!;
      }
      _onChanged();
    });
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 251,
      height: 50,
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: widget.preFixIcon != null
              ? Icon(
                  widget.preFixIcon,
                  color: Color(0xFF768196),
                )
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
                            address: address));
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  icon: Icon(
                    widget.suffixIcon,
                    color: Color(0xFF768196),
                  ),
                )
              : widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
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
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
