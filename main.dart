import 'package:flutter/material.dart';
import 'home.dart'; 
import 'chat_page.dart'; 
import 'anxiety_result_page.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(), // Starts with your home UI
      routes: {
        '/home': (context) => const Home(),
        '/chat': (context) => const ChatPage(),
        '/anxiety': (context) => const AnxietyResultPage()
      },
    );
  }
}
