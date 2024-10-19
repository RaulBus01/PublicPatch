import 'package:flutter/material.dart';

class CustomFormInput extends StatefulWidget {
  final String title;
  final bool obscureText;

  const CustomFormInput({super.key, required this.title, this.obscureText = false});

  @override
  State<CustomFormInput> createState() => _CustomFormInputState();
}

class _CustomFormInputState extends State<CustomFormInput> {
  late bool _obscureText;
  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 251,
      height: 50,
      child: TextFormField(
        decoration: InputDecoration(
          suffixIcon: widget.obscureText
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
