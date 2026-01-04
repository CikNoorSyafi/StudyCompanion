import 'package:flutter/material.dart';

class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onClose;

  const ErrorBanner({Key? key, required this.message, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) return const SizedBox.shrink();
    return Semantics(
      liveRegion: true,
      label: 'Error: $message',
      child: Container(
        color: Theme.of(context).colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 14))),
            if (onClose != null)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: onClose,
                tooltip: 'Dismiss error',
              ),
          ],
        ),
      ),
    );
  }
}
