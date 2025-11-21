import 'dart:io';

import 'package:flutter/material.dart';
import '../../widgets/image_input.dart';

import 'package:image_picker/image_picker.dart';
import '../../controllers/artikel_controller.dart';

class ArticelFormScreen extends StatefulWidget {
  final bool isEdit;
  final String? artikelId;
  const ArticelFormScreen({super.key, required this.isEdit, this.artikelId});

  @override
  State<ArticelFormScreen> createState() => _ArticelFormScreenState();
}

class _ArticelFormScreenState extends State<ArticelFormScreen> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? imagePath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _create(String title, String description) async {
    if (imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar terlebih dahulu')),
      );
      return;
    }
    final imageFile = File(imagePath!);

    final message = await ArtikelController.createArtikel(
      imageFile,
      title,
      description,
      context,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _update(String title, String description) async{
    File? imageFile;
    if (imagePath != null) {
      imageFile = File(imagePath!);
    }

    final message = await ArtikelController.updateArtikel(
      id: widget.artikelId!,
      title: title.isNotEmpty ? title : null,
      description: description.isNotEmpty ? description : null,
      image: imageFile,
      context: context
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isEdit ? 'Edit Artikel' : 'Tambah Artikel',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          backgroundColor: const Color(0XFFD1A824),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UploadGambarBox(onTap: _pickImage, imagePath: imagePath),
              SizedBox(height: 20),
              Text(
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
              ),
              const SizedBox(height: 10),
              Text(
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
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              final title = judulController.text;
              final description = descriptionController.text;

              if (widget.isEdit == false) {
                _create(title, description);
              } else if (widget.isEdit && widget.artikelId != null) {
                _update(title, description);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0XFFD1A824),
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
            ),
            child: Text(
              widget.isEdit ? 'Edit' : 'Tambah',
              style: TextStyle(
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
