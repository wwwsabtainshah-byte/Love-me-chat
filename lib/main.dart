import 'package:flutter/material.dart';

void main() {
  runApp(const LovelyChatApp());
}

class LovelyChatApp extends StatelessWidget {
  const LovelyChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lovely Chat',
      debugShowCheckedModeBanner: false,
      // رائل پرپل اور گولڈ تھیم
      theme: ThemeData(
        primaryColor: const Color(0xFF4B0082), // Indigo/Royal Purple
        scaffoldBackgroundColor: const Color(0xFF120024), // Dark Purple BG
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4B0082),
          secondary: const Color(0xFFFFD700), // Gold
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lovely Chat', 
          style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)
        ),
        backgroundColor: const Color(0xFF1A0033),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Welcome to Lovely Chat\nTikTok + Mego System Ready!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
