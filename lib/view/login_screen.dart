import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/view/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = "/login_screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 128),
                Text(
                  "Welcome Back !",
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
                SizedBox(height: 8),
                Text(
                  "Please login to your account",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(height: 100),
                buildTextField(label: "Email"),
                SizedBox(height: 24),
                buildTextField(label: "Password"),
                SizedBox(height: 300),
                SizedBox(
                  width: 256,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.blackButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 28),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: '  Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildTextField({required String label, bool obscureText = false}) {
  return TextFormField(
    obscureText: obscureText,
    style: TextStyle(color: Colors.white), // warna teks input
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
      fillColor: AppColor.blackField,
      filled: true,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(26),
      ),
    ),
  );
}
