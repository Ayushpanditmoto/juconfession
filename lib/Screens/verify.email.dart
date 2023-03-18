import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juconfession/utils/route.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isLoaded = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
            stream: auth.authStateChanges(),
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome ${auth.currentUser!.email}'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Please verify your email to continue'),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        setState(() {
                          isLoaded = true;
                        });

                        auth.currentUser!.sendEmailVerification();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Verification email sent'),
                          ),
                        );
                      } catch (e) {
                        setState(() {
                          isLoaded = false;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error sending verification email'),
                          ),
                        );
                      }
                    },
                    child: isLoaded
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text('Resend email'),
                  ),
                  //Refresh button
                  //Logout button
                  ElevatedButton(
                    onPressed: () {
                      auth.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          RoutePath.login, (Route<dynamic> route) => false);
                    },
                    child: const Text('Logout'),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
