import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:publicpatch/models/LocationData.dart';
import 'package:publicpatch/utils/geolocationFunctions.dart';

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
  loc.Location location = loc.Location();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (widget.content != null) {
        _controller.text = widget.content!;
      }
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
                      if (await Geolocator.isLocationServiceEnabled() ==
                          false) {
                        final status = await location.requestService();
                        if (status == false) {
                          widget.controller.text =
                              'Location service is disabled';
                          return;
                        }
                      }
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
                      debugPrint('Error getting location: $e');
                      widget.controller.text = '';
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
