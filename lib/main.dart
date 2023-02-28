import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
      ],
      child: Builder(builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'JU Confessions',
          theme: CustomTheme.lightTheme(),
          darkTheme: CustomTheme.darkTheme(),
          themeMode: themeProvider.themeMode,
          home: const Login(),
          initialRoute: RoutePath.login,
          onGenerateRoute: RoutePath.generateRoute,
        );
      }),
    );
  }
}
