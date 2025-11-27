// login_screen.dart (tidak ada perubahan signifikan, hanya pastikan imports benar)
import 'package:artikel_wisata/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/bottom_navbar.dart'; // Tambahkan import ini

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFFF6F2E5),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2.8,
                decoration: const BoxDecoration(
                  color: Color(0XFFD1A824),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: const Align( // Tambahkan const
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage('assets/images/login.png'),
                    width: 250,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text( // Tambahkan const
                'Login',
                style: TextStyle(
                  color: Color(0XFFD1A824),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20), // Tambahkan const
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10), // Tambahkan const
                    const Text( // Tambahkan const
                      'Username',
                      style: TextStyle(
                        color: Color(0XFFD1A824),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5), // Tambahkan const
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Username Kamu',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide( // Tambahkan const
                            color: Color(0XFFD1A824),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide( // Tambahkan const
                            color: Color(0XFFD1A824),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric( // Tambahkan const
                          vertical: 20.0,
                          horizontal: 15.0,
                        ),
                      ),
                    ),
                    const Text( // Tambahkan const
                      'Password',
                      style: TextStyle(
                        color: Color(0XFFD1A824),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5), // Tambahkan const
                    TextFormField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Password Kamu',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide( // Tambahkan const
                            color: Color(0XFFD1A824),
                            width: 2,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide( // Tambahkan const
                            color: Color(0XFFD1A824),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric( // Tambahkan const
                          vertical: 20.0,
                          horizontal: 15.0,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color(0XFFD1A824),
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 5), // Tambahkan const
                    const Text( // Tambahkan const
                      'Lupa Password ?',
                      style: TextStyle(color: Color(0XFFD1A824)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20), // Tambahkan const
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final message = await AuthController.login(
                    context, 
                    usernameController.text, 
                    passwordController.text
                    );

                    ScaffoldMessenger.of(
                      context,
                      ).showSnackBar(SnackBar(content: Text(message)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFFD1A824),
                  minimumSize: const Size(double.infinity, 55), // Tambahkan const
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text( // Tambahkan const
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFFF6F2E5), // Gunakan backgroundColor
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0XFFD1A824)), // Tambahkan const
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Color(0XFFD1A824),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}