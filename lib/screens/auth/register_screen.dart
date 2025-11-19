import 'package:artikel_wisata/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isObscure = true;

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
                child: Align(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage('assets/images/login.png'),
                    width: 250,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Register',
                style: TextStyle(
                  color: Color(0XFFD1A824),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),

                    // NAME
                    Text(
                      'Name',
                      style: TextStyle(
                        color: Color(0XFFD1A824),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Masukkan Nama Kamu',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0XFFD1A824),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0XFFD1A824),
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    // USERNAME
                    Text(
                      'Username',
                      style: TextStyle(
                        color: Color(0XFFD1A824),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Masukkan Username Anda',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0XFFD1A824),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0xFFD1A824),
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    // PASSWORD
                    Text(
                      'Password',
                      style: TextStyle(
                        color: Color(0XFFD1A824),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 5),
                    TextFormField(
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        hintText: 'Masukkan Password Anda',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0XFFD1A824),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Color(0XFFD1A824),
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
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
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () => {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFFD1A824),
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
                child: Text(
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
                  backgroundColor: Color(0XFFF6F2E5),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0XFFD1A824)),
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
