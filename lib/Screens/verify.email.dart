// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isButtonVisible = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  int secondsRemaining = 30;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      if (secondsRemaining == 0) {
        setState(() {
          isButtonVisible = true;
        });
        timer.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  void checkEmailVerified() async {
    await auth.currentUser!.reload();
    if (auth.currentUser!.emailVerified) {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({'isVerified': true});
      Navigator.of(context).pushNamedAndRemoveUntil(
          RoutePath.confess, (Route<dynamic> route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email not verified'),
        ),
      );
    }
  }

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
                  //Timer
                  Text('Resend email in $secondsRemaining seconds'),

                  //Verify button
                  ElevatedButton(
                    onPressed: () {
                      try {
                        setState(() {
                          isLoaded = true;
                        });
                        checkEmailVerified();
                        setState(() {
                          isLoaded = false;
                        });
                      } catch (e) {
                        setState(() {
                          isLoaded = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error verifying email'),
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
                        : const Text('Check Verification Status'),
                  ),

                  //Resend button
                  if (isButtonVisible)
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
                          setState(() {
                            isLoaded = false;
                            secondsRemaining = 120;
                            isButtonVisible = false;
                            startTimer();
                          });
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
