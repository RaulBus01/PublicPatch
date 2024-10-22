import 'package:flutter/material.dart';

class BottomPanel extends StatelessWidget {
  final Icon icon;
  final List<Widget> menuOptions;

  const BottomPanel({super.key, required this.icon, required this.menuOptions});

  void _showBottomPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
            color: Color(0xFF1B1D29),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                menuOptions, // Here the options passed from parent widget are displayed
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomPanel(context),
      child: icon, // Trigger the modal when icon is tapped
    );
  }
}
