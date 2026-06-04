import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/database_helper.dart';
import 'transaction_history_screen.dart';

class ReceiptScreen extends StatefulWidget {
  final String mlId;
  final String server;
  final int diamond;
  final int price;
  final int discount;
  final int total;
  final String paymentMethod;

  const ReceiptScreen({
    super.key,
    required this.mlId,
    required this.server,
    required this.diamond,
    required this.price,
    required this.discount,
    required this.total,
    required this.paymentMethod,
  });

  @override
  State<ReceiptScreen> createState() =>
      _ReceiptScreenState();
}

class _ReceiptScreenState
    extends State<ReceiptScreen> {

  late String trxId;

  @override
  void initState() {
    super.initState();

    trxId = generateTransactionId();

    saveTransaction();
  }

  Future<void> saveTransaction() async {

    final db = DatabaseHelper();

    await db.saveTransaction(
      transactionId: trxId,
      mlId: widget.mlId,
      serverId: widget.server,
      diamond: widget.diamond,
      price: widget.price,
      discount: widget.discount,
      total: widget.total,
      paymentMethod:
          widget.paymentMethod,
      date:
          DateTime.now().toString(),
      status: "SUCCESS",
    );
  }

  String generateTransactionId() {
    DateTime now = DateTime.now();

    return "TRX"
        "${now.year}"
        "${now.month.toString().padLeft(2, '0')}"
        "${now.day.toString().padLeft(2, '0')}"
        "${now.hour.toString().padLeft(2, '0')}"
        "${now.minute.toString().padLeft(2, '0')}"
        "${now.second.toString().padLeft(2, '0')}";
  }

  Widget buildRow(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign:
                  TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Receipt"),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding:
                const EdgeInsets.all(
                    20),
            child: Column(
              children: [

                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100,
                ),

                const SizedBox(
                    height: 10),

                const Text(
                  "PEMBAYARAN BERHASIL",
                  style: TextStyle(
                    color:
                        Colors.green,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 22,
                  ),
                ),

                const Divider(),

                buildRow(
                  "No Transaksi",
                  trxId,
                ),

                buildRow(
                  "Tanggal",
                  DateFormat(
                    "dd MMM yyyy",
                  ).format(now),
                ),

                buildRow(
                  "Jam",
                  DateFormat(
                    "HH:mm:ss",
                  ).format(now),
                ),

                buildRow(
                  "ID ML",
                  widget.mlId,
                ),

                buildRow(
                  "Server",
                  widget.server,
                ),

                buildRow(
                  "Diamond",
                  "${widget.diamond}",
                ),

                buildRow(
                  "Harga",
                  "Rp ${widget.price}",
                ),

                buildRow(
                  "Diskon",
                  "Rp ${widget.discount}",
                ),

                buildRow(
                  "Metode",
                  widget.paymentMethod,
                ),

                const Divider(),

                buildRow(
                  "TOTAL",
                  "Rp ${widget.total}",
                ),

                const SizedBox(
                    height: 25),

                ElevatedButton.icon(
                  icon:
                      const Icon(
                    Icons.history,
                  ),
                  label: const Text(
                    "LIHAT RIWAYAT",
                  ),
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const TransactionHistoryScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(
                    height: 10),

                ElevatedButton.icon(
                  icon:
                      const Icon(
                    Icons.home,
                  ),
                  label: const Text(
                    "SELESAI",
                  ),
                  onPressed: () {

                    Navigator.popUntil(
                      context,
                      (route) =>
                          route.isFirst,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}