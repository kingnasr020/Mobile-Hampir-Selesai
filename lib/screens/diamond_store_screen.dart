import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/database_helper.dart';
import 'checkout_screen.dart';
import 'quiz_screen.dart';

class DiamondStoreScreen extends StatefulWidget {
  const DiamondStoreScreen({super.key});

  @override
  State<DiamondStoreScreen> createState() => _DiamondStoreScreenState();
}

class _DiamondStoreScreenState extends State<DiamondStoreScreen> {
  final TextEditingController mlIdController = TextEditingController();

  final TextEditingController serverController = TextEditingController();

  final TextEditingController converterController = TextEditingController();

  int userCoin = 0;

  String selectedCurrency = "USD";

  double convertedResult = 0;

  final Map<String, double> rates = {
    "USD": 16500,
    "EUR": 18000,
    "SGD": 12200,
    "JPY": 110,
  };

  final List<Map<String, dynamic>> diamonds = [
    {"diamond": 86, "price": 20000},
    {"diamond": 172, "price": 40000},
    {"diamond": 257, "price": 60000},
    {"diamond": 344, "price": 80000},
    {"diamond": 429, "price": 100000},
    {"diamond": 514, "price": 120000},
    {"diamond": 706, "price": 160000},
    {"diamond": 878, "price": 200000},
    {"diamond": 963, "price": 220000},
    {"diamond": 1412, "price": 320000},
    {"diamond": 2195, "price": 480000},
    {"diamond": 3688, "price": 800000},
  ];

  @override
  void initState() {
    super.initState();
    loadCoin();
  }

  Future<void> loadCoin() async {
    try {
      final db = DatabaseHelper();

      final coin = await db.getCoins();

      if (mounted) {
        setState(() {
          userCoin = coin;
        });
      }
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }

  void convertCurrency() {
    double amount = double.tryParse(
          converterController.text,
        ) ??
        0;

    setState(() {
      convertedResult = amount / rates[selectedCurrency]!;
    });
  }

  Widget buildDiamondCard(
    int diamond,
    int price,
  ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.diamond,
              color: Colors.blue,
              size: 45,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "$diamond Diamond",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Rp ${NumberFormat('#,###').format(price)}",
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                if (mlIdController.text.isEmpty ||
                    serverController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Isi ID ML dan Server terlebih dahulu",
                      ),
                    ),
                  );

                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CheckoutScreen(
                      mlId: mlIdController.text,
                      server: serverController.text,
                      diamond: diamond,
                      price: price,
                      userCoin: userCoin,
                    ),
                  ),
                );
              },
              child: const Text("BELI"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildClock(
    String title,
    int offset,
  ) {
    DateTime utc = DateTime.now().toUtc().add(
          Duration(
            hours: offset,
          ),
        );

    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          DateFormat(
            "HH:mm:ss",
          ).format(utc),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MLBB Diamond Store",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BANNER

            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage(
                    "assets/images/profile.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller: mlIdController,
              decoration: const InputDecoration(
                labelText: "ID Mobile Legends",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            TextField(
              controller: serverController,
              decoration: const InputDecoration(
                labelText: "Server ID",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Card(
              color: Colors.amber.shade100,
              child: ListTile(
                leading: const Icon(
                  Icons.monetization_on,
                ),
                title: const Text(
                  "Coin Anda",
                ),
                trailing: Text(
                  "$userCoin Coin",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(
              "PAKET DIAMOND",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: diamonds.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                return buildDiamondCard(
                  diamonds[index]["diamond"],
                  diamonds[index]["price"],
                );
              },
            ),

            const SizedBox(
              height: 25,
            ),

            const Text(
              "LIVE WORLD CLOCK",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            buildClock("WIB", 7),

            buildClock("WITA", 8),

            buildClock("WIT", 9),

            buildClock("LONDON", 0),

            const SizedBox(
              height: 25,
            ),

            const Text(
              "CURRENCY CONVERTER",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            TextField(
              controller: converterController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Input Rupiah",
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                convertCurrency();
              },
            ),

            const SizedBox(
              height: 10,
            ),

            DropdownButton<String>(
              value: selectedCurrency,
              isExpanded: true,
              items: rates.keys
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value!;
                });

                convertCurrency();
              },
            ),

            const SizedBox(
              height: 10,
            ),

            Text(
              "${convertedResult.toStringAsFixed(2)} $selectedCurrency",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  55,
                ),
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const QuizScreen(),
                  ),
                );

                if (result == true) {
                  await loadCoin();

                  if (mounted) {
                    setState(() {});
                  }
                }
              },
              icon: const Icon(
                Icons.sports_esports,
              ),
              label: const Text(
                "MAIN QUIZ UNTUK DAPAT COIN",
              ),
            ),

            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
