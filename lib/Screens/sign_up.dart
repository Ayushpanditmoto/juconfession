// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:juconfession/services/auth.firebase.dart';
import 'package:juconfession/utils/utils.dart';

import '../components/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  bool isLogin = false;
  File? _image;

  @override
  void dispose() {
    nameController.dispose();
    departmentController.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 94, 255),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //svg image
                SvgPicture.asset(
                  'assets/signup.svg',
                  height: 250,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                MemoryImage(_image!.readAsBytesSync()),
                            backgroundColor: Colors.red,
                          )
                        : const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                'https://i.stack.imgur.com/l60Hf.png'),
                            backgroundColor: Colors.red,
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    )
                  ],
                ),
                TextEnterArea(
                  hintText: 'Name',
                  controller: nameController,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.black54,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                TextEnterArea(
                  hintText: 'Department',
                  controller: departmentController,
                  prefixIcon: const Icon(
                    Icons.person_search,
                    color: Colors.black54,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                //username text field
                TextEnterArea(
                  hintText: 'Username',
                  controller: usernameController,
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.black54,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                TextEnterArea(
                  hintText: 'Email',
                  controller: emailController,
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.black54,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),

                // password text field
                TextEnterArea(
                  hintText: 'Password',
                  controller: passwordController,
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.black54,
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: false,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 10),
                // login button
                ElevatedButton(
                  onPressed: () async {
                    try {
                      setState(() {
                        isLogin = true;
                      });
                      String result = await AuthMethod().signUpUser(
                          email: emailController.text,
                          password: passwordController.text,
                          name: nameController.text,
                          image: File(_image!.path).readAsBytesSync(),
                          department: departmentController.text);

                      setState(() {
                        isLogin = false;
                      });

                      showSnackBar(result, context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Something went wrong'),
                        ),
                      );
                    }

                    // Navigator.pushNamed(context, RoutePath.confess);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    minimumSize: const Size(160, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLogin
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
