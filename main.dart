import 'package:flutter/material.dart';
import 'home.dart';
import 'chat_page.dart';
import 'anxiety_result_page.dart';
import 'profile.dart';
import 'insights_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const Home(),
      routes: {
        '/profile': (context) => const Profile(),
        '/home': (context) => const Home(),
        '/chat': (context) => const ChatPage(),
        '/anxiety': (context) => const AnxietyResultPage(),
        '/insights': (context) => const InsightsPage(),
      },
    );
  }
}
