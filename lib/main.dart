import 'package:flutter/material.dart';
import 'Katalog Produk.dart';
import 'opening.dart';
import 'Beranda.dart';
import 'Kontak.dart' ;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Refi Frozen Food',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Di sini kamu bisa pilih mau munculin apa dulu:
      // 1. SplashScreenAdmin() -> Biasanya untuk pembuka
      // 2. KatalogPage() -> Langsung ke daftar produk
      // 3. Beranda() -> Menu utama
      home: const SplashScreenAdmin(), 
    );
  }
}