import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DetailPengeluaran extends StatelessWidget {
  final QueryDocumentSnapshot doc;

  const DetailPengeluaran({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final amount = (doc['amount'] as num).toInt();
    final description = doc['description'];
    final category = doc['category'];
    final date = (doc['date'] as Timestamp).toDate();
    final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(date);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pengeluaran')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kategori: $category', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Jumlah: Rp$amount', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Deskripsi: $description', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Tanggal: $formattedDate', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
