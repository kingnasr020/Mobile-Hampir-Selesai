import 'package:flutter/material.dart';

class BeritaDetailScreen extends StatelessWidget {
  final Map<String, String> beritaData;

  const BeritaDetailScreen({Key? key, required this.beritaData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF102A43)),
          onPressed: () => Navigator.pop(context), // FIX: Diganti jadi onPressed
        ),
        title: const Text(
          "Detail Berita",
          style: TextStyle(color: Color(0xFF102A43), fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Berita
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                image: DecorationImage(
                  image: AssetImage(beritaData['image']!),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  // Tambahan errorBuilder jaga-jaga kalau gambar gagal load saat demo
                  // Ini penting banget biar nggak layar merah
                ),
              ),
              // Manual error handling untuk image container jika asset belum ada
              child: Image.asset(
                beritaData['image']!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.image_not_supported_rounded, size: 50, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag & Tanggal
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "HOT NEWS",
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.access_time_rounded, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        beritaData['date']!,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Judul Berita
                  Text(
                    beritaData['title']!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF102A43),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Sumber Berita
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        backgroundColor: Color(0xFF102A43),
                        child: Icon(Icons.newspaper_rounded, size: 14, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Sumber: ${beritaData['source']!}",
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  const Divider(height: 40, thickness: 1),
                  
                  // Isi Konten Berita
                  Text(
                    beritaData['content']!,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.8,
                      letterSpacing: 0.2,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}