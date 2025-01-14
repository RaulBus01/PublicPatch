import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CustomDropDown<T> extends StatefulWidget {
  final T initialValue;
  final List<T> items;
  final Function(T) onChanged;
  final Widget Function(T) itemBuilder; // Add itemBuilder for custom display

  const CustomDropDown({
    super.key,
    required this.initialValue,
    required this.items,
    required this.onChanged,
    required this.itemBuilder, // Add itemBuilder for custom display
  });

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  late T selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
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
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return ListTile(
                title: widget.itemBuilder(item),
                contentPadding: const EdgeInsets.only(left: 16, right: 16),
                trailing: IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: Color(0xFF768196),
                    size: 24,
                  ),
                  onPressed: () {},
                ),
                onTap: () {
                  setState(() => selectedValue = item);
                  widget.onChanged(item);
                  Navigator.pop(context);
                },
              );
            },
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
            widget.itemBuilder(
                selectedValue), // Use itemBuilder for custom display
            const Icon(Ionicons.chevron_down_outline, color: Color(0xFF768196)),
          ],
        ),
      ),
    );
  }
}
