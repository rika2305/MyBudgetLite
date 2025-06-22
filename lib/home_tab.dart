import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final user = FirebaseAuth.instance.currentUser;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  List<int> years = List.generate(5, (index) => DateTime.now().year - index);
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DropdownButton<int>(
                value: selectedMonth,
                items:
                    List.generate(12, (i) => i + 1).map((month) {
                      return DropdownMenuItem(
                        value: month,
                        child: Text(
                          DateFormat.MMMM().format(DateTime(0, month)),
                        ),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => selectedMonth = val!),
              ),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: selectedYear,
                items:
                    years.map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => selectedYear = val!),
              ),
            ],
          ),
          const SizedBox(height: 12),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection('pengeluaran')
                    .where('uid', isEqualTo: user?.uid)
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final docs = snapshot.data!.docs;

              final filteredDocs =
                  docs.where((doc) {
                    final tgl = (doc['tanggal'] as Timestamp).toDate();
                    return tgl.month == selectedMonth &&
                        tgl.year == selectedYear;
                  }).toList();

              final total = filteredDocs.fold<int>(
                0,
                (acc, doc) => acc + (doc['jumlah'] as int),
              );

              final Map<String, double> kategoriMap = {};
              for (var doc in filteredDocs) {
                final kategori = doc['kategori'];
                final jumlah = (doc['jumlah'] as int).toDouble();
                kategoriMap[kategori] = (kategoriMap[kategori] ?? 0) + jumlah;
              }

              final pieData = kategoriMap.entries.toList();
              final totalDouble = total.toDouble();
              final List<Color> colors = [
                Colors.blue,
                Colors.green,
                Colors.orange,
                Colors.red,
                Colors.purple,
                Colors.teal,
                Colors.brown,
              ];

              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total: ${formatter.format(total)}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    if (pieData.isNotEmpty)
                      SizedBox(
                        height: 160,
                        child: PieChart(
                          PieChartData(
                            sections:
                                pieData.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final e = entry.value;
                                  final percent = ((e.value / totalDouble) *
                                          100)
                                      .toStringAsFixed(1);
                                  return PieChartSectionData(
                                    title: "$percent%",
                                    value: e.value,
                                    radius: 50,
                                    color: colors[index % colors.length],
                                    titleStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      )
                    else
                      const Text("Tidak ada data."),
                    const SizedBox(height: 16),
                    const Text(
                      "Pengeluaran:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final data = filteredDocs[index];
                          final docId = data.id;
                          final tanggal =
                              (data['tanggal'] as Timestamp).toDate();
                          final kategori = data['kategori'] ?? '-';
                          final jumlah = data['jumlah'];
                          final deskripsi = data['deskripsi'] ?? '';

                          return ListTile(
                            title: Text(kategori),
                            subtitle: Text(
                              "${DateFormat('dd/MM/yyyy').format(tanggal)} - $deskripsi",
                            ),
                            trailing: Text(formatter.format(jumlah)),
                            onTap: () {
                              final jumlahCtrl = TextEditingController(
                                text: jumlah.toString(),
                              );
                              final deskCtrl = TextEditingController(
                                text: deskripsi,
                              );
                              String? kategoriBaru = kategori;
                              DateTime? tanggalBaru = tanggal;

                              showDialog(
                                context: context,
                                builder:
                                    (ctx) => AlertDialog(
                                      title: const Text("Edit Pengeluaran"),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: jumlahCtrl,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                labelText: 'Jumlah',
                                              ),
                                            ),
                                            TextField(
                                              controller: deskCtrl,
                                              decoration: const InputDecoration(
                                                labelText: 'Deskripsi',
                                              ),
                                            ),
                                            DropdownButtonFormField<String>(
                                              value: kategoriBaru,
                                              items:
                                                  [
                                                        "Makanan",
                                                        "Transportasi",
                                                        "Belanja",
                                                        "Perawatan Diri",
                                                        "Lainnya",
                                                      ]
                                                      .map(
                                                        (e) => DropdownMenuItem(
                                                          value: e,
                                                          child: Text(e),
                                                        ),
                                                      )
                                                      .toList(),
                                              onChanged:
                                                  (val) => kategoriBaru = val,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    DateFormat(
                                                      'dd/MM/yyyy',
                                                    ).format(tanggalBaru!),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    final picked =
                                                        await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              tanggalBaru!,
                                                          firstDate: DateTime(
                                                            2023,
                                                          ),
                                                          lastDate: DateTime(
                                                            2100,
                                                          ),
                                                        );
                                                    if (picked != null) {
                                                      setState(
                                                        () =>
                                                            tanggalBaru =
                                                                picked,
                                                      );
                                                    }
                                                  },
                                                  child: const Text(
                                                    "Ubah Tanggal",
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Batal"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final newJumlah = int.tryParse(
                                              jumlahCtrl.text,
                                            );
                                            if (newJumlah != null &&
                                                kategoriBaru != null &&
                                                tanggalBaru != null) {
                                              await FirebaseFirestore.instance
                                                  .collection('pengeluaran')
                                                  .doc(docId)
                                                  .update({
                                                    'jumlah': newJumlah,
                                                    'kategori': kategoriBaru,
                                                    'deskripsi': deskCtrl.text,
                                                    'tanggal':
                                                        Timestamp.fromDate(
                                                          tanggalBaru!,
                                                        ),
                                                  });
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                            }
                                          },
                                          child: const Text("Simpan"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('pengeluaran')
                                                .doc(docId)
                                                .delete();
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text(
                                            "Hapus",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
