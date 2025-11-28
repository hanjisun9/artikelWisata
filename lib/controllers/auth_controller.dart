import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/auth/login_screen.dart';
import '../services/auth_service.dart';
import '../widgets/bottom_navbar.dart';
import '../models/user_model.dart';

class AuthController {
  // Register
  static Future<String> register(
    BuildContext context,
    String name,
    String username,
    String password,
  ) async {
    final result = await AuthService.register(name, username, password);
    final responseData = jsonDecode(result.body);

    if (result.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return responseData['message'] ?? "Registrasi berhasil";
    } else {
      if (result.statusCode == 400) {
        final firstError = responseData['errors'][0];
        return firstError['message'] ?? "Terjadi kesalahan";
      } else {
        return responseData['message'] ?? "Terjadi kesalahan";
      }
    }
  }

  // Login
  static Future<String> login(
    BuildContext context,
    String username,
    String password,
  ) async {
    final result = await AuthService.login(username, password);
    final responseData = jsonDecode(result.body);

    if (result.statusCode == 200) {
      final token = responseData['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      // TIDAK clear local_user_data agar foto profile tetap tersimpan
      // Hanya update data dari server jika perlu, tapi tetap pertahankan profileImage lokal

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavbar()),
      );

      return responseData['message'] ?? "Login berhasil";
    } else {
      if (result.statusCode == 400) {
        final firstError = responseData['errors'][0];
        return firstError['message'] ?? "Terjadi kesalahan";
      }
      return responseData['message'] ?? 'Login gagal';
    }
  }

  // Get Profile
  static Future<User> getProfile() async {
    final prefs = await SharedPreferences.getInstance();

    // Cek data lokal dulu
    final localUserData = prefs.getString('local_user_data');

    if (localUserData != null && localUserData.isNotEmpty) {
      try {
        final localData = jsonDecode(localUserData);
        return User.fromJson(localData);
      } catch (e) {
        await prefs.remove('local_user_data');
      }
    }

    // Jika tidak ada data lokal, ambil dari API
    final result = await AuthService.getProfile();

    if (result.statusCode == 200) {
      final responseData = jsonDecode(result.body);
      final data = responseData['data'];
      
      // Simpan data dari API ke lokal
      final user = User.fromJson(data);
      await prefs.setString('local_user_data', jsonEncode(user.toJson()));
      
      return user;
    } else {
      final responseData = jsonDecode(result.body);
      throw Exception(responseData['message'] ?? 'Gagal memuat data user');
    }
  }

  // Update Profile Local (tanpa API) - Diperbarui dengan profileImage
  static Future<String> updateProfileLocal({
    required String name,
    required String username,
    String? profileImage,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Ambil data yang ada
      String oldId = '';
      String? oldProfileImage;
      final localUserData = prefs.getString('local_user_data');

      if (localUserData != null && localUserData.isNotEmpty) {
        final localData = jsonDecode(localUserData);
        oldId = localData['id']?.toString() ?? '';
        oldProfileImage = localData['profileImage']?.toString();
      }

      // Jika tidak ada local data, ambil ID dari API
      if (oldId.isEmpty) {
        try {
          final result = await AuthService.getProfile();
          if (result.statusCode == 200) {
            final responseData = jsonDecode(result.body);
            oldId = responseData['data']['id']?.toString() ?? '';
          }
        } catch (e) {
          // Ignore
        }
      }

      // Buat user baru - gunakan foto baru jika ada, kalau tidak pakai yang lama
      final updatedUser = User(
        id: oldId,
        name: name,
        username: username,
        profileImage: profileImage ?? oldProfileImage,
      );

      // Simpan ke SharedPreferences
      await prefs.setString('local_user_data', jsonEncode(updatedUser.toJson()));

      return 'Profile berhasil diupdate';
    } catch (e) {
      return 'Gagal mengupdate profile: $e';
    }
  }

  // Update Profile Image Only
  static Future<String> updateProfileImage(String base64Image) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localUserData = prefs.getString('local_user_data');

      if (localUserData != null && localUserData.isNotEmpty) {
        final localData = jsonDecode(localUserData);
        localData['profileImage'] = base64Image;
        await prefs.setString('local_user_data', jsonEncode(localData));
        return 'Foto profile berhasil diupdate';
      } else {
        // Jika belum ada data lokal, buat baru
        final result = await AuthService.getProfile();
        if (result.statusCode == 200) {
          final responseData = jsonDecode(result.body);
          final data = responseData['data'];
          data['profileImage'] = base64Image;
          await prefs.setString('local_user_data', jsonEncode(data));
          return 'Foto profile berhasil diupdate';
        }
        return 'Gagal mengupdate foto profile';
      }
    } catch (e) {
      return 'Gagal mengupdate foto profile: $e';
    }
  }

  // Get Profile Image
  static Future<String?> getProfileImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localUserData = prefs.getString('local_user_data');

      if (localUserData != null && localUserData.isNotEmpty) {
        final localData = jsonDecode(localUserData);
        return localData['profileImage']?.toString();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Logout
  static Future<String> logout(BuildContext context) async {
    try {
      final result = await AuthService.Logout();
      final responseData = jsonDecode(result.body);

      // Hanya hapus token, TIDAK hapus local_user_data agar foto tetap ada
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

      return responseData['message'] ?? 'Logout berhasil';
    } catch (e) {
      // Tetap logout meski error
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

      return 'Logout berhasil';
    }
  }
}