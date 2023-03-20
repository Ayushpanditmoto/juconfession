import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:juconfession/Screens/home.dart';
import 'package:juconfession/provider/user.provider.dart';
import 'package:juconfession/services/auth.firebase.dart';
import 'package:upgrader/upgrader.dart';
import 'Screens/login_page.dart';
import 'Screens/nointernet.dart';
import 'Screens/verify.email.dart';
import 'firebase_options.dart';
import 'provider/theme_provider.dart';
import 'utils/route.dart';
import 'package:provider/provider.dart';
import './utils/theme_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Connectivity connectivity = Connectivity();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Builder(builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return UpgradeAlert(
          upgrader: Upgrader(
            showReleaseNotes: true,
            shouldPopScope: () => true,
            // canDismissDialog: true,
            // debugLogging: true,
            durationUntilAlertAgain: const Duration(
              minutes: 60,
            ),
            dialogStyle: UpgradeDialogStyle.material,
          ),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'JU Confessions',
            theme: CustomTheme.lightTheme(),
            darkTheme: CustomTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
            // initialRoute: RoutePath.login, this is enemy
            onGenerateRoute: RoutePath.generateRoute,
            home: StreamBuilder(
                stream: connectivity.onConnectivityChanged,
                builder: (context, snapshot) {
                  if (snapshot.data == ConnectivityResult.none) {
                    return const NoInternet();
                  }
                  return StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        //chec whether user is banned or not
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final DocumentSnapshot documentSnapshot =
                                    snapshot.data as DocumentSnapshot;
                                if (documentSnapshot.data() == null) {
                                  return const Login();
                                }
                                if ((documentSnapshot.data()
                                        as dynamic)['isVerified'] ==
                                    false) {
                                  return const VerifyEmail();
                                }

                                if ((documentSnapshot.data()
                                        as dynamic)['isBanned'] ==
                                    true) {
                                  return Scaffold(
                                    body: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //image
                                        const Center(
                                          child: Text(
                                            'You are banned',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/ban.png',
                                          height: 200,
                                          width: 200,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            AuthMethod().logout();
                                          },
                                          child: const Text('Logout'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return const Confession();
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            });
                      } else {
                        return const Login();
                      }
                    },
                  );
                }),
          ),
        );
      }),
    );
  }
}
