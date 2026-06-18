import 'dart:async';
import 'package:flutter/material.dart';

class UpdateS41Screen extends StatefulWidget {
  const UpdateS41Screen({super.key});

  @override
  State<UpdateS41Screen> createState() => _UpdateS41ScreenState();
}

class _UpdateS41ScreenState extends State<UpdateS41Screen> {
  Timer? _timer;
  String _countdownText = "";
  
  // Waktu Live
  DateTime _wibTime = DateTime.now();
  DateTime _witaTime = DateTime.now();
  DateTime _witTime = DateTime.now();
  DateTime _londonTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Target Reset: 15 September 2026, 15:00 WIB
    final DateTime targetDate = DateTime(2026, 9, 15, 15, 0, 0); 

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      
      final DateTime now = DateTime.now();
      
      // Update Countdown
      final Duration difference = targetDate.difference(now);
      if (difference.isNegative) {
        _countdownText = "SEASON 41 TELAH DIMULAI!";
      } else {
        _countdownText = "${difference.inDays} Hari : ${(difference.inHours % 24).toString().padLeft(2, '0')} Jam : ${(difference.inMinutes % 60).toString().padLeft(2, '0')} Menit : ${(difference.inSeconds % 60).toString().padLeft(2, '0')} Detik";
      }

      // Update Jam Dunia
      DateTime utcNow = now.toUtc();
      setState(() {
        _wibTime = utcNow.add(const Duration(hours: 7));   // WIB (UTC+7)
        _witaTime = utcNow.add(const Duration(hours: 8));  // WITA (UTC+8)
        _witTime = utcNow.add(const Duration(hours: 9));   // WIT (UTC+9)
        _londonTime = utcNow.add(const Duration(hours: 1)); // London (BST/Summer Time UTC+1)
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9), // Warna background soft ala EsportsPulse
      appBar: AppBar(
        backgroundColor: const Color(0xFF102A43),
        title: const Text('Update Season & Clock', style: TextStyle(color: Colors.white, fontSize: 16)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- KARTU COUNTDOWN UTAMA ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF102A43), // Navy Blue solid matching your theme
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.timer_outlined, color: Colors.amber, size: 40),
                  const SizedBox(height: 12),
                  const Text(
                    "SISA WAKTU MENUJU SEASON 41",
                    style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _countdownText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Reset Server: 15:00 WIB",
                    style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // --- LIVE WORLD CLOCK SESUAI GAMBAR ---
            const Text(
              "LIVE WORLD CLOCK",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF102A43), letterSpacing: 0.5),
            ),
            const SizedBox(height: 12),

            _buildClockRow("WIB", _wibTime),
            _buildClockRow("WITA", _witaTime),
            _buildClockRow("WIT", _witTime),
            _buildClockRow("LONDON", _londonTime),
          ],
        ),
      ),
    );
  }

  Widget _buildClockRow(String timezone, DateTime time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            timezone, 
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF102A43), letterSpacing: 0.5)
          ),
          Text(
            _formatTime(time),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87, fontFeatures: [FontFeature.tabularFigures()]),
          ),
        ],
      ),
    );
  }
}