import 'package:flutter/material.dart';

class CustomTextArea extends StatefulWidget {
  final String title;
  final IconData? preFixIcon;
  const CustomTextArea({super.key, required this.title, this.preFixIcon});

  @override
  State<CustomTextArea> createState() => _CustomTextAreaState();
}

class _CustomTextAreaState extends State<CustomTextArea> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 251,
      child: TextField(
        minLines: 1,
        maxLines: 6,
        selectionControls: MaterialTextSelectionControls(),
        decoration: InputDecoration(
          prefixIcon: widget.preFixIcon != null
              ? Icon(
                  widget.preFixIcon,
                  color: Color(0xFF768196),
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
        autocorrect: true,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
