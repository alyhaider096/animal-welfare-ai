import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'utils/theme_provider.dart';
import 'screen/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const primary = Color(0xFFF6B48B);
  static const bgLight = Color(0xFFFDF7F3);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Animal Welfare',
            themeMode: theme.mode,

            theme: ThemeData(
              useMaterial3: true,
              primaryColor: primary,
              scaffoldBackgroundColor: bgLight,
              textTheme: GoogleFonts.poppinsTextTheme(),
              colorScheme: ColorScheme.fromSeed(seedColor: primary),
            ),

            darkTheme: ThemeData.dark(useMaterial3: true),

            // 🌟 SPLASH ENTRY POINT
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
