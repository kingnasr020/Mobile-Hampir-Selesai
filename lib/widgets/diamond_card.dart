import 'package:flutter/material.dart';

class DiamondCard extends StatelessWidget {
  final int diamond;
  final int price;
  final VoidCallback onBuy;

  const DiamondCard({
    super.key,
    required this.diamond,
    required this.price,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.diamond,
              color: Colors.blue,
              size: 50,
            ),

            const SizedBox(height: 10),

            Text(
              "$diamond Diamond",
              style: const TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Rp $price",
              style: const TextStyle(
                color: Colors.green,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: onBuy,
              child: const Text(
                "BELI",
              ),
            ),
          ],
        ),
      ),
    );
  }
}