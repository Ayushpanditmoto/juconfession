// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juconfession/services/auth.firebase.dart';
import 'package:juconfession/services/firestore.methods.dart';
import 'package:juconfession/utils/route.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isLoaded = false;
  bool isLoaded1 = false;
  bool isButtonVisible = false;

  FirebaseAuth auth = AuthMethod().auth;
  FirebaseFirestore firestore = FirestoreMethods().firestore;

  int secondsRemaining = 30;

  @override
  void initState() {
    super.initState();
    startTimer();
    //sent email verification

    sendEmailVerification();
  }

  void sendEmailVerification() async {
    try {
      await auth.currentUser!.sendEmailVerification();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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
    // await auth.currentUser!.reload();
    if (auth.currentUser!.emailVerified) {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({'isVerified': true});
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     RoutePath.confess, (Route<dynamic> route) => false);

      Navigator.of(context).pushNamedAndRemoveUntil(
          RoutePath.home, (Route<dynamic> route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email not verified'),
        ),
      );
    }
  }

  //check user verified or not from database
  Future<bool> isVerified() async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      //check if isVerified is available or not
      if (documentSnapshot.data() as dynamic == null) {
        return false;
      }
      return (documentSnapshot.data() as dynamic)['isVerified'] ?? false;
    } catch (e) {
      rethrow;
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
                  Text(
                      'Welcome ${auth.currentUser != null ? auth.currentUser!.email : ''}'),
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
                    onPressed: () async {
                      try {
                        setState(() {
                          isLoaded1 = true;
                        });
                        checkEmailVerified();
                        setState(() {
                          isLoaded1 = false;
                        });
                      } catch (e) {
                        setState(() {
                          isLoaded1 = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error verifying email'),
                          ),
                        );
                      }
                    },
                    child: isLoaded1
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
