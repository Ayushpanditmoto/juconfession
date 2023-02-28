import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/custom_text_field.dart';
import '../utils/route.dart';

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

  @override
  void dispose() {
    nameController.dispose();
    departmentController.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
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
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                      backgroundColor: Colors.red,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          //disabling the button
                        },
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
                    onPressed: () {
                      Navigator.pushNamed(context, RoutePath.confess);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      minimumSize: const Size(160, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Sign Up',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
