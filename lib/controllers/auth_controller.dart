import 'dart:convert';
import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../services/auth_service.dart';

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
}