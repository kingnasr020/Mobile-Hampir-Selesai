import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Posisi target (Aim Trainer)
  double targetX = 100.0;
  double targetY = 200.0;
  
  // Stream untuk sensor
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    
    // 1. Sensor Gyroscope: Gerakin target pakai kemiringan HP (Poin 8 & 10)
    _streamSubscriptions.add(
      gyroscopeEvents.listen((GyroscopeEvent event) {
        setState(() {
          // x dan y diatur agar target bergerak halus saat HP miring
          targetX = (targetX + event.y * 15).clamp(0, MediaQuery.of(context).size.width - 50);
          targetY = (targetY + event.x * 15).clamp(0, MediaQuery.of(context).size.height - 200);
        });
      }),
    );

    // 2. Sensor Accelerometer: Fitur Shake untuk reset game (Poin 8)
    _streamSubscriptions.add(
      accelerometerEvents.listen((AccelerometerEvent event) {
        // Jika guncangan (X atau Y) lebih dari 15, maka reset
        if (event.x.abs() > 15 || event.y.abs() > 15) {
          _resetTarget();
        }
      }),
    );
  }

  void _resetTarget() {
    setState(() {
      targetX = 150.0;
      targetY = 250.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Shake Detected! Position Reset."),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Stack(
        children: [
          const Positioned(
            top: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Esports Aim Trainer", style: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                Text("Goyangkan HP untuk Reset | Miringkan HP untuk Aim", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          
          // Target Game
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            left: targetX,
            top: targetY,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.red, blurRadius: 15)],
              ),
              child: const Icon(Icons.gps_fixed, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}