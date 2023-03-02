import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:juconfession/Screens/home.dart';
import 'package:juconfession/provider/user.provider.dart';
import 'Screens/login_page.dart';
import 'firebase_options.dart';
import 'provider/theme_provider.dart';
import 'utils/route.dart';
import 'package:provider/provider.dart';
import './utils/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Builder(builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'JU Confessions',
          theme: CustomTheme.lightTheme(),
          darkTheme: CustomTheme.darkTheme(),
          themeMode: themeProvider.themeMode,
          // initialRoute: RoutePath.login, this is enemy
          onGenerateRoute: RoutePath.generateRoute,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const Confession();
              } else {
                return const Login();
              }
            },
          ),
        );
      }),
    );
  }
}
