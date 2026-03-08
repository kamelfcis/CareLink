import 'dart:typed_data';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? imagePath;
  final Uint8List? imageBytes;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.imagePath,
    this.imageBytes,
  }) : timestamp = timestamp ?? DateTime.now();
}
