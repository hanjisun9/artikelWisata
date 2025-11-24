import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';

class UploadGambarBox extends StatelessWidget {
  final VoidCallback onTap;
  final String? imagePath;       // fallback Mobile
  final Uint8List? imageBytes;   // utama: Web & Mobile

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
      try {
        provider = FileImage(File(imagePath!));
      } catch (_) {
        provider = null;
      }
    }

    // Batasi lebar di Web supaya tidak di-upscale berlebihan
    Widget content = AspectRatio(
      aspectRatio: 2, // lebar : tinggi = 2:1 (mirip sebelumnya width/2)
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
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
                    )
                  ],
                )
              : Image(
                  image: provider,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high, // preview lebih tajam
                  isAntiAlias: true,
                  width: double.infinity,
                  height: double.infinity,
                ),
        ),
      ),
    );

    if (kIsWeb) {
      content = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720), // max width Web
          child: content,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: content,
    );
  }
}