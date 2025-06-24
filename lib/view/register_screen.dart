import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ppkd_flutter/constant/app_color.dart';
import 'package:ppkd_flutter/view/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String id = "/resgister_screen";

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                  "Create a new account",
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
                SizedBox(height: 8),
                Text(
                  "Please fill in the form to continue",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(height: 100),
                buildTextField(label: "Full Name"),
                SizedBox(height: 24),
                buildTextField(label: "Email"),
                SizedBox(height: 24),
                buildTextField(label: "Phone Number"),
                SizedBox(height: 24),
                buildTextField(label: "Password"),
                SizedBox(height: 150),
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
                      'SIGN IN',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 28),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: '  Login',
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
                                    builder: (context) => LoginScreen(),
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
