import 'package:flutter/material.dart';
import 'package:gismite/pages/createpost.dart';
import 'package:gismite/pages/map_page.dart';
import 'package:gismite/pages/msginfo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:gismite/pages/account_page.dart';
// import 'package:gismite/pages/login_page.dart';
import 'package:gismite/pages/msginboxalerts.dart';
import 'package:gismite/pages/posts.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
//   await Supabase.initialize(
//     url: dotenv.get("SUPABASE_URL"),
//     anonKey: dotenv.get("SUPABASE_ANON_KEY"),
//   );
//   runApp(const MyApp());
}

// final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange,
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange,
          ),
        ),
      ),
      themeMode: ThemeMode
          .system, // Automatically switch themes based on system settings
      home: const Posts(),
      routes: {
        '/message_info': (context) => const MessageInfo(),
      },
    );
  }
}

extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(this).colorScheme.error
            : Theme.of(this).snackBarTheme.backgroundColor,
      ),
    );
  }
}
