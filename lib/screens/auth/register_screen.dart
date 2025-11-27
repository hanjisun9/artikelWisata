// register_screen.dart (tidak ada perubahan signifikan, hanya pastikan imports benar)
import 'package:artikel_wisata/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isObscure = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0XFFF6F2E5), // Tambahkan const
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
              const SizedBox(height: 20), // Tambahkan const
              const Text( // Tambahkan const
                'Register',
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

                    // NAME
                    const Text( // Tambahkan const
                      'Name',
                      style: TextStyle(
                        color: Color(0XFFD1A824),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5), // Tambahkan const
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Nama Kamu',
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
                          vertical: 20,
                          horizontal: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15), // Tambahkan const

                    // USERNAME
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
                        hintText: 'Masukkan Username Anda',
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
                            color: Color(0xFFD1A824),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric( // Tambahkan const
                          vertical: 20,
                          horizontal: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15), // Tambahkan const

                    // PASSWORD
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
                        hintText: 'Masukkan Password Anda',
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
                          vertical: 20,
                          horizontal: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0XFFD1A824), // Tambahkan const
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
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
                  final message = await AuthController.register(
                    context, 
                    nameController.text, 
                    usernameController.text, 
                    passwordController.text,
                    );
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(message)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFFD1A824),
                  minimumSize: const Size(double.infinity, 55), // Tambahkan const
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Gunakan BorderRadius.circular
                  ),
                ),
                child: const Text( // Tambahkan const
                  'Register',
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
                      builder: (context) => const LoginScreen(),
                    ),
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
                  'Login',
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