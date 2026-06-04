import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../services/database_helper.dart';
import '../services/session_manager.dart';
import 'receipt_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final String mlId;
  final String server;
  final int diamond;
  final int price;
  final int userCoin;

  const CheckoutScreen({
    super.key,
    required this.mlId,
    required this.server,
    required this.diamond,
    required this.price,
    required this.userCoin,
  });

  @override
  State<CheckoutScreen> createState() =>
      _CheckoutScreenState();
}

class _CheckoutScreenState
    extends State<CheckoutScreen> {

  final TextEditingController passwordController =
      TextEditingController();

  final LocalAuthentication auth =
      LocalAuthentication();

  bool useCoin = false;

  String paymentMethod = "BCA";

  int get discount {

    if (!useCoin) return 0;

    if (widget.userCoin >= 100) {
      return 10000;
    }

    if (widget.userCoin >= 50) {
      return 5000;
    }

    if (widget.userCoin >= 20) {
      return 2500;
    }

    return 1000;
  }

  int get finalPrice {
    return widget.price - discount;
  }

  Future<void> processBiometric() async {

    try {

      bool canCheck =
          await auth.canCheckBiometrics;

      bool supported =
          await auth.isDeviceSupported();

      if (canCheck || supported) {

        bool success =
            await auth.authenticate(
          localizedReason:
              "Verifikasi pembayaran",
        );

        if (success) {
          await finishPayment();
        }
      }

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Biometrik gagal : $e",
          ),
        ),
      );
    }
  }

  Future<void> processPassword() async {

    String? username =
        await SessionManager.getUsername();

    if (username == null) {

      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Error"),
          content: Text(
            "Session login tidak ditemukan",
          ),
        ),
      );

      return;
    }

    final db = DatabaseHelper();

    bool valid =
        await db.verifyPassword(
      username,
      passwordController.text,
    );

    if (!valid) {

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            "Pembayaran Gagal",
          ),
          content: const Text(
            "Password akun salah",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
              ),
            ),
          ],
        ),
      );

      return;
    }

    await finishPayment();
  }

  Future<void> finishPayment() async {

    final db = DatabaseHelper();

    if (useCoin) {

      int usedCoin = 0;

      if (widget.userCoin >= 100) {
        usedCoin = 100;
      } else if (widget.userCoin >= 50) {
        usedCoin = 50;
      } else if (widget.userCoin >= 20) {
        usedCoin = 20;
      } else {
        usedCoin = 10;
      }

      await db.useCoin(usedCoin);
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ReceiptScreen(
          mlId: widget.mlId,
          server: widget.server,
          diamond: widget.diamond,
          price: widget.price,
          discount: discount,
          total: finalPrice,
          paymentMethod: paymentMethod,
        ),
      ),
    );
  }

  Widget paymentTile(String name) {

    return RadioListTile<String>(
      value: name,
      groupValue: paymentMethod,
      title: Text(name),
      onChanged: (value) {

        setState(() {
          paymentMethod = value!;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checkout",
        ),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "DETAIL PEMBELIAN",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const Divider(),

                    Text(
                      "ID ML : ${widget.mlId}",
                    ),

                    Text(
                      "Server : ${widget.server}",
                    ),

                    Text(
                      "Diamond : ${widget.diamond}",
                    ),

                    Text(
                      "Harga : Rp ${widget.price}",
                    ),

                    const SizedBox(
                      height: 15,
                    ),

                    CheckboxListTile(
                      value: useCoin,
                      title: Text(
                        "Gunakan Coin (${widget.userCoin})",
                      ),
                      onChanged: (value) {

                        setState(() {
                          useCoin =
                              value ?? false;
                        });
                      },
                    ),

                    Text(
                      "Diskon : Rp $discount",
                    ),

                    Text(
                      "Total : Rp $finalPrice",
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Column(
                children: [

                  const ListTile(
                    title: Text(
                      "PILIH PEMBAYARAN",
                    ),
                  ),

                  paymentTile("BCA"),
                  paymentTile("BRI"),
                  paymentTile("BNI"),
                  paymentTile("MANDIRI"),
                  paymentTile("DANA"),
                  paymentTile("OVO"),
                  paymentTile("GOPAY"),
                  paymentTile("SHOPEEPAY"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller:
                  passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText:
                    "Password Akun",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child:
                  ElevatedButton.icon(
                icon:
                    const Icon(Icons.lock),
                label: const Text(
                  "BAYAR ",
                ),
                onPressed:
                    processPassword,
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,
              child:
                  ElevatedButton.icon(
                icon: const Icon(
                  Icons.fingerprint,
                ),
                label: const Text(
                  "BIOMETRIK",
                ),
                onPressed:
                    processBiometric,
              ),
            ),
          ],
        ),
      ),
    );
  }
}