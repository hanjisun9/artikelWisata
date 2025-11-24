import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/image_input.dart';
import '../../controllers/artikel_controller.dart';

class ArticelFormScreen extends StatefulWidget {
  final bool isEdit;
  final String? artikelId;
  const ArticelFormScreen({super.key, required this.isEdit, this.artikelId});

  @override
  State<ArticelFormScreen> createState() => _ArticelFormScreenState();
}

class _ArticelFormScreenState extends State<ArticelFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController judulController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Simpan bytes + filename agar aman di Web & Mobile
  Uint8List? _imageBytes;
  XFile? _pickedFile; // untuk ambil nama file
  String? imagePath;  // opsional (fallback untuk Mobile), tidak dipakai di Web

  bool _isLoading = false;

  @override
  void dispose() {
    judulController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickImage() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Pilih Sumber Gambar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Kamera'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galeri'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _pickedFile = picked;
          _imageBytes = bytes;
          // Hanya isi imagePath untuk non-Web (untuk fallback),
          // di Web path berupa blob: yang tidak bisa dipakai FileImage.
          imagePath = kIsWeb ? null : picked.path;
        });
      }
    } catch (e) {
      _showSnack('Gagal mengambil gambar: $e');
    }
  }

  Future<void> _create(String title, String description) async {
    if (_imageBytes == null) {
      _showSnack('Pilih gambar terlebih dahulu');
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final message = await ArtikelController.createArtikelWithBytes(
        imageBytes: _imageBytes!,
        imageName: _pickedFile?.name ?? 'image.jpg',
        title: title,
        description: description,
        context: context,
      );
      _showSnack(message);
    } catch (e) {
      _showSnack('Terjadi kesalahan: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _update(String title, String description) async {
    if (widget.artikelId == null) {
      _showSnack('ID artikel tidak ditemukan');
      return;
    }

    final noTitle = title.trim().isEmpty;
    final noDesc = description.trim().isEmpty;
    final noImage = _imageBytes == null;

    if (noTitle && noDesc && noImage) {
      _showSnack('Tidak ada perubahan untuk diperbarui');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final message = await ArtikelController.updateArtikelWithBytes(
        id: widget.artikelId!,
        title: title.isNotEmpty ? title : null,
        description: description.isNotEmpty ? description : null,
        imageBytes: _imageBytes, // boleh null
        imageName: _pickedFile?.name,
        context: context,
      );
      _showSnack(message);
    } catch (e) {
      _showSnack('Terjadi kesalahan: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final btnLabel = widget.isEdit ? 'Edit' : 'Tambah';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isEdit ? 'Edit Artikel' : 'Tambah Artikel',
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          backgroundColor: const Color(0XFFD1A824),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              if (_isLoading) return;
              Navigator.pop(context);
            },
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upload box sekarang bisa render dari bytes (aman di Web)
                UploadGambarBox(
                  onTap: _pickImage,
                  imageBytes: _imageBytes,
                  imagePath: imagePath, // fallback untuk Mobile (tidak dipakai di Web)
                ),
                const SizedBox(height: 20),
                const Text(
                  'Judul Artikel',
                  style: TextStyle(
                    color: Color(0XFF4D4637),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: judulController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Nama Lokasi',
                    isDense: true,
                    hintStyle: const TextStyle(
                      color: Color(0XFFD9D9D9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0XFFD9D9D9),
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (!widget.isEdit && (value == null || value.trim().isEmpty)) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'Deskripsi',
                  style: TextStyle(
                    color: Color(0XFF4D4637),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 5,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Deskripsi Lokasi',
                    hintStyle: const TextStyle(
                      color: Color(0XFFD9D9D9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0XFFD9D9D9),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0XFFD9D9D9),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  validator: (value) {
                    if (!widget.isEdit && (value == null || value.trim().isEmpty)) {
                      return 'Deskripsi tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final title = judulController.text.trim();
                    final description = descriptionController.text.trim();

                    if (widget.isEdit == false) {
                      await _create(title, description);
                    } else if (widget.isEdit && widget.artikelId != null) {
                      await _update(title, description);
                    } else {
                      _showSnack('Mode edit tetapi artikelId tidak tersedia');
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0XFFD1A824),
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Memproses...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : Text(
                    btnLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}