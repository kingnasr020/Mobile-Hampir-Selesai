import 'dart:io';
import 'package:flutter/foundation.dart'; // Wajib untuk mendeteksi Web/HP
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:esportspulse/screens/login_screen.dart';

// Class pembantu untuk mengabaikan batasan sertifikasi keamanan lokal/regional luar
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  // Wajib dipanggil untuk inisialisasi binding Flutter sebelum async
  WidgetsFlutterBinding.ensureInitialized();
  
  // Mengaktifkan bypass konfigurasi jaringan (hanya jika dijalankan di perangkat asli/bukan web)
  if (!kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }
  
  // Memuat file .env dari folder assets dengan sistem pengaman
  try {
    await dotenv.load(fileName: "assets/.env");
    debugPrint("✅ SUKSES: File .env berhasil dimuat!");
  } catch (e) {
    debugPrint("❌ BAHAYA: File .env GAGAL dimuat! Error: $e");
    // Walau error, aplikasi akan dipaksa lanjut agar tidak stuck di logo
  }
  
  runApp(const EsportsPulseApp());
}

class EsportsPulseApp extends StatelessWidget {
  const EsportsPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EsportsPulse',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: const Color(0xFF102A43),
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF102A43),
          primary: const Color(0xFF102A43),
          secondary: const Color(0xFF62B1F6),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF102A43),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF102A43),
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF102A43),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      home: const LoginScreen(), 
    );
  }
}