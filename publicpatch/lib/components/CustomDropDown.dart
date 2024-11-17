import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CustomDropDown<T> extends StatefulWidget {
  final T initialValue;
  final List<T> items;

  const CustomDropDown({
    super.key,
    required this.initialValue,
    required this.items,
  });

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  late T initialValue;

  @override
  void initState() {
    super.initState();
    initialValue = widget.initialValue;
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1B1D29),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.items.map((T value) {
              return Material(
                borderRadius: BorderRadius.circular(5),
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Color(0xFF768196),
                  child: ListTile(
                    minVerticalPadding: 20,
                    title: Row(
                      children: [
                        Padding(padding: const EdgeInsets.only(right: 10)),
                        Icon(
                          Icons.category,
                          color: const Color(0xFF768196),
                        ),
                        Padding(padding: const EdgeInsets.only(right: 10)),
                        Text(
                          value.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    iconColor: Colors.white,
                    onTap: () {
                      setState(() {
                        initialValue = value;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showBottomSheet,
      child: Container(
        width: 251,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1D29),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0xFF768196), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.category,
                  color: const Color(0xFF768196),
                ),
                Padding(padding: const EdgeInsets.only(right: 10)),
                Text(
                  initialValue.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            const Icon(Ionicons.chevron_down_outline, color: Color(0xFF768196)),
          ],
        ),
      ),
    );
  }
}
