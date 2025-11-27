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

      // Clear local data saat login baru
      await prefs.remove('local_user_data');

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
      return User.fromJson(data);
    } else {
      final responseData = jsonDecode(result.body);
      throw Exception(responseData['message'] ?? 'Gagal memuat data user');
    }
  }

  // Update Profile Local (tanpa API)
  static Future<String> updateProfileLocal({
    required String name,
    required String username,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Ambil ID dari data yang ada
      String odlId = '';
      final localUserData = prefs.getString('local_user_data');

      if (localUserData != null && localUserData.isNotEmpty) {
        final localData = jsonDecode(localUserData);
        odlId = localData['id']?.toString() ?? '';
      }

      // Jika tidak ada local data, ambil ID dari API
      if (odlId.isEmpty) {
        try {
          final result = await AuthService.getProfile();
          if (result.statusCode == 200) {
            final responseData = jsonDecode(result.body);
            odlId = responseData['data']['id']?.toString() ?? '';
          }
        } catch (e) {
          // Ignore
        }
      }

      // Buat user baru
      final updatedUser = User(
        id: odlId,
        name: name,
        username: username,
      );

      // Simpan ke SharedPreferences
      await prefs.setString('local_user_data', jsonEncode(updatedUser.toJson()));

      return 'Profile berhasil diupdate';
    } catch (e) {
      return 'Gagal mengupdate profile: $e';
    }
  }

  // Logout
  static Future<String> logout(BuildContext context) async {
    try {
      final result = await AuthService.Logout();
      final responseData = jsonDecode(result.body);

      // Clear semua data lokal
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('local_user_data');
      await prefs.remove('token');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

      return responseData['message'] ?? 'Logout berhasil';
    } catch (e) {
      // Tetap logout meski error
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('local_user_data');
      await prefs.remove('token');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

      return 'Logout berhasil';
    }
  }
}