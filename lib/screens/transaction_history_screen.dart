import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends State<TransactionHistoryScreen> {

  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final db = DatabaseHelper();

    final data =
        await db.getTransactions();

    setState(() {
      transactions = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Riwayat Transaksi"),
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Text(
                "Belum ada transaksi",
              ),
            )
          : ListView.builder(
              itemCount:
                  transactions.length,
              itemBuilder:
                  (context, index) {

                final trx =
                    transactions[index];

                return Card(
                  margin:
                      const EdgeInsets.all(
                    10,
                  ),
                  child: ListTile(
                    leading:
                        const Icon(
                      Icons.receipt,
                    ),
                    title: Text(
                      "${trx['diamond']} Diamond",
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [

                        Text(
                          "ID ML : ${trx['ml_id']}",
                        ),

                        Text(
                          "Server : ${trx['server_id']}",
                        ),

                        Text(
                          "Pembayaran : ${trx['payment_method']}",
                        ),

                        Text(
                          "Total : Rp ${trx['total']}",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}