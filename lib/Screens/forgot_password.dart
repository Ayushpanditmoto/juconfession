// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:juconfession/components/custom_text_field.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void forgotPassword() async {
    try {
      if (_formKey.currentState!.validate() == false) return;

      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: controller.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset link sent to your email'),
        ),
      );
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/forgot.svg',
                height: 300,
              ),
              const SizedBox(height: 50),
              Container(
                // height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: TextEnterArea(
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.black54,
                      ),
                      controller: controller,
                      hintText: 'Email',
                      validator: (p0) {
                        if (p0!.isEmpty) {
                          return 'Please enter your email';
                        } else if (!p0.contains('@gmail.com')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      }),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: forgotPassword,
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  backgroundColor: const Color.fromARGB(255, 186, 186, 186),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Send Password Reset Link',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
