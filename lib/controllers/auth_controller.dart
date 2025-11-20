import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/auth/login_screen.dart';
import '../services/auth_service.dart';
import '../screens/home/home_screen.dart';

class AuthController {
  static Future<String> register(
    BuildContext context,
    String name,
    String username,
    String password,
  )async {
    final result = await AuthService.register(name, username, password);
    final responseData = jsonDecode(result.body);

    if (result.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(),)
        );
        return responseData['message'] ?? "Registrasi berhasil";
    } else{
      if (result.statusCode == 400) {
        final firstError = responseData['errors'][0];
        return (firstError['message'] ?? "Terjadi kesalahan");
      } else {
        return (responseData['message'] ?? "Terjadi kesalahan");
      }
    }
  }

  static Future<String> login(
    BuildContext context,
    String username,
    String password,
  ) async{
    final result = await AuthService.login(username, password);
    final responseData = jsonDecode(result.body);

    if (result.statusCode == 200){
      final token = responseData['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        );

        return responseData['message'] ?? "Login berhasil";
    }else{
      if (result.statusCode == 400) {
        final firstError = responseData['errors'][0];
        return (firstError['message'] ?? "Terjadi kesalahan");
      }
      return(responseData['message'] ?? 'Login gagal');
    }
  }
}