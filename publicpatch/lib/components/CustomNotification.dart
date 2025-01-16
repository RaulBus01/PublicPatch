import 'package:flutter/material.dart';

class CustomNotification extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final DateTime? time;
  final String reportId;
  final Function()? onDismissed;
  final Function()? onArchive;
  final Function(String reportId)? onTap;

  const CustomNotification({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.reportId,
    this.time,
    this.onDismissed,
    this.onTap,
    this.onArchive,
  });

  @override
  State<CustomNotification> createState() => _CustomNotificationState();
}

class _CustomNotificationState extends State<CustomNotification> {
  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            backgroundColor: const Color(0xFF1B1D29),
            title: const Text(
              'Delete Notification',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            content: const Text(
              'Are you sure you want to delete this notification?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xff9DA4B3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          // Delete action
          final shouldDelete = await _showDeleteConfirmation(context);
          if (shouldDelete && widget.onDismissed != null) {
            widget.onDismissed!();
          }
          return shouldDelete;
        }

        return false;
      },
      background: Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerRight,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!(widget.reportId);
          }
        },
        child: Container(
          decoration: const BoxDecoration(
              color: Color(0xFF1B1D29),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(widget.icon, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF9DA4B3),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.time != null)
                Text(
                  '${widget.time!.hour}:${widget.time!.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
