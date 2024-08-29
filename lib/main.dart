import 'package:flutter/material.dart';
import 'package:gismite/pages/createpost.dart';
import 'package:gismite/pages/map_page.dart';
import 'package:gismite/pages/msginfo.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:gismite/pages/account_page.dart';
// import 'package:gismite/pages/login_page.dart';
import 'package:gismite/pages/msginboxalerts.dart';
import 'package:gismite/pages/posts.dart';

Future<void> main() async {
  // await Supabase.initialize(
  //   url: 'https://xbkgfrrhvxyavmhtghnf.supabase.co',
  //   anonKey:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhia2dmcnJodnh5YXZtaHRnaG5mIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjIwNzQ3OTIsImV4cCI6MjAzNzY1MDc5Mn0.nsx6F03AdsCwvSyciykTdHgBmuEteee7dHG7oiJXCNs',
  // );
  runApp(const MyApp());
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
      home: const CreatePost(),
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
