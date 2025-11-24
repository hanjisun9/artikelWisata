import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';

class UploadGambarBox extends StatelessWidget {
  final VoidCallback onTap;
  final String? imagePath;       // fallback untuk Mobile
  final Uint8List? imageBytes;   // utama, aman untuk Web & Mobile

  const UploadGambarBox({
    super.key,
    required this.onTap,
    this.imagePath,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? provider;

    if (imageBytes != null) {
      provider = MemoryImage(imageBytes!);
    } else if (imagePath != null) {
      // Hanya akan kepakai di Mobile. Di Web path = blob: (abaikan).
      try {
        provider = FileImage(File(imagePath!));
      } catch (_) {
        provider = null;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.width / 2,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          image: provider != null
              ? DecorationImage(image: provider, fit: BoxFit.cover)
              : null,
        ),
        child: provider == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.image, size: 70, color: Colors.black54),
                  SizedBox(height: 8),
                  Text(
                    'Upload Gambar',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}