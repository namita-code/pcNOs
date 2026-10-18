import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isSignUp = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUp() async {
    try {
      // Replace with controllers if you add them
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );

      Navigator.pushReplacementNamed(context, '/symptoms');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign Up failed: $e")),
      );
    }
  }

  Future<void> _signIn() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signed in successfully!")),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign In failed: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient:  LinearGradient(
            colors: [?Colors.pink[100], ?Colors.pink[200]],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(30),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 25,
                    spreadRadius: 3,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite, color: Colors.pinkAccent, size: 60),
                  const SizedBox(height: 10),

                  // App Title
                  Text(
                    "pcNOs",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Empower. Educate. Embrace.",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 30),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: isSignUp
                          ? _buildSignUpForm()
                          : _buildSignInForm()
                  ),

                  const SizedBox(height: 20),

                  // Switch between SignIn/SignUp
                  GestureDetector(
                    onTap: () => setState(() => isSignUp = !isSignUp),
                    child: RichText(
                      text: TextSpan(
                        text: isSignUp
                            ? "Already have an account? "
                            : "Don’t have an account? ",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[800],
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: isSignUp ? "Sign In" : "Sign Up",
                            style: GoogleFonts.poppins(
                              color: Colors.pinkAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {bool isPassword = false, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.pinkAccent),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.pinkAccent),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Column(
      key: const ValueKey(1),
      children: [
        _buildTextField("Email", controller: _emailController),
        _buildTextField("Password", isPassword: true, controller: _passwordController),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Forgot Password?",
            style: GoogleFonts.poppins(
              color: Colors.pinkAccent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _primaryButton("Sign In"),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      key: const ValueKey(2),
      children: [
        _buildTextField("Full Name", controller: _nameController),
        _buildTextField("Email", controller: _emailController),
        _buildTextField("Password", isPassword: true, controller: _passwordController),
        _buildTextField("Confirm Password", isPassword: true, controller: _confirmPasswordController),
        const SizedBox(height: 20),
        _primaryButton("Create Account"),
      ],
    );
  }

  Widget _primaryButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pinkAccent,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: Colors.pinkAccent.withValues(alpha: 0.5),
      ),
      onPressed: () async {
        if (isSignUp) {
          await _signUp();
        } else {
          await _signIn();
        }
      },
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}

