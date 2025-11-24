import 'dart:io';
import 'dart:typed_data';
import 'package:artikel_wisata/widgets/bottom_navbar.dart';
import 'package:http/http.dart' as http;

import 'package:artikel_wisata/services/artikel_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/artikel_model.dart';

class ArtikelController {
  static Future<List<Artikel>> getArtikel(int page, int limit) async {
    final result = await ArtikelService.getArtikel(page, limit);
    if (result.statusCode == 200) {
      final data = jsonDecode(result.body)['data'] as List<dynamic>?;
      return data?.map((item) => Artikel.fromJson(item)).toList() ?? [];
    } else {
      throw Exception('Gagal memuat data artikel');
    }
  }

  static Future<List<Artikel>> getMyArtikel(int page, int limit) async {
    final result = await ArtikelService.getMyArtikel(page, limit);

    if (result.statusCode == 200) {
      final data = jsonDecode(result.body)['data'] as List<dynamic>?;
      return data?.map((item) => Artikel.fromJson(item)).toList() ?? [];
    } else if (result.statusCode == 400) {
      throw ('Kamu belum mempunyai artikel');
    } else {
      throw ('Gagal memuat data artikel');
    }
  }

  // =============== VERSI LAMA (File) — BIARKAN TETAP ADA ===============
  static Future<String> createArtikel(
    File image,
    String title,
    String description,
    BuildContext context,
  ) async {
    final result = await ArtikelService.createArtikel(image, title, description);

    final response = await http.Response.fromStream(result);
    final objectResponse = jsonDecode(response.body);

    if (response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavbar()),
      );
      return objectResponse['message'] ?? 'Tambah data berhasil';
    } else if (response.statusCode == 400) {
      final firstError = objectResponse['errors'][0];
      return (firstError['message'] ?? 'Terjadi kesalahan');
    } else {
      return (objectResponse['message'] ?? 'Terjadi kesalahan');
    }
  }

  static Future<String> updateArtikel({
    required String id,
    File? image,
    String? title,
    String? description,
    required BuildContext context,
  }) async {
    final result = await ArtikelService.updateArtikel(
      id: id,
      image: image,
      title: title,
      description: description,
    );

    final response = await http.Response.fromStream(result);
    final objectResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavbar()),
      );
      return objectResponse['message'] ?? 'Update data berhasil';
    } else if (response.statusCode == 400) {
      final firstError = objectResponse['errors']?[0];
      return firstError?['message'] ?? 'Terjadi kesalahan';
    } else {
      return objectResponse['message'] ?? 'Terjadi kesalahan';
    }
  }

  // =============== VERSI BARU (BYTES) — AMAN UNTUK WEB ===============
  static Future<String> createArtikelWithBytes({
    required Uint8List imageBytes,
    required String imageName,
    required String title,
    required String description,
    required BuildContext context,
  }) async {
    final result = await ArtikelService.createArtikelBytes(
      imageBytes: imageBytes,
      imageName: imageName,
      title: title,
      description: description,
    );

    final response = await http.Response.fromStream(result);
    final objectResponse = jsonDecode(response.body);

    if (response.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavbar()),
      );
      return objectResponse['message'] ?? 'Tambah data berhasil';
    } else if (response.statusCode == 400) {
      final firstError = objectResponse['errors']?[0];
      return firstError?['message'] ?? 'Terjadi kesalahan';
    } else {
      return objectResponse['message'] ?? 'Terjadi kesalahan';
    }
  }

  static Future<String> updateArtikelWithBytes({
    required String id,
    Uint8List? imageBytes,
    String? imageName,
    String? title,
    String? description,
    required BuildContext context,
  }) async {
    final result = await ArtikelService.updateArtikelBytes(
      id: id,
      imageBytes: imageBytes,
      imageName: imageName,
      title: title,
      description: description,
    );

    final response = await http.Response.fromStream(result);
    final objectResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavbar()),
      );
      return objectResponse['message'] ?? 'Update data berhasil';
    } else if (response.statusCode == 400) {
      final firstError = objectResponse['errors']?[0];
      return firstError?['message'] ?? 'Terjadi kesalahan';
    } else {
      return objectResponse['message'] ?? 'Terjadi kesalahan';
    }
  }

  static Future<String> deleteArtikel(String id, BuildContext context) async {
    final result = await ArtikelService.deleteArtikel(id);

    final responseData = jsonDecode(result.body);

    if (result.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavbar()),
      );
      return responseData['message'] ?? ' Delete data berhasil';
    } else {
      return (responseData['message'] ?? 'Terjadi kesalahan');
    }
  }
}