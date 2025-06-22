import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TambahPengeluaranTab extends StatefulWidget {
  const TambahPengeluaranTab({super.key});

  @override
  State<TambahPengeluaranTab> createState() => _TambahPengeluaranTabState();
}

class _TambahPengeluaranTabState extends State<TambahPengeluaranTab> {
  final jumlahController = TextEditingController();
  final deskripsiController = TextEditingController();
  String? kategoriTerpilih;
  DateTime? tanggalTerpilih;

  final List<String> kategoriList = [
    "Makanan",
    "Transportasi",
    "Belanja",
    "Perawatan Diri",
    "Lainnya",
  ];

  Future<void> simpanPengeluaran() async {
    if (jumlahController.text.isEmpty ||
        kategoriTerpilih == null ||
        tanggalTerpilih == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua data')),
      );
      return;
    }

    final jumlah = int.tryParse(jumlahController.text);
    if (jumlah == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Jumlah tidak valid')));
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('pengeluaran').add({
        'uid': user.uid,
        'jumlah': jumlah,
        'kategori': kategoriTerpilih,
        'deskripsi': deskripsiController.text,
        'tanggal': Timestamp.fromDate(tanggalTerpilih!),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengeluaran berhasil disimpan')),
      );

      jumlahController.clear();
      deskripsiController.clear();
      setState(() {
        kategoriTerpilih = null;
        tanggalTerpilih = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menyimpan data')));
    }
  }

  Future<void> pilihTanggal() async {
    final tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (tanggal != null && mounted) {
      setState(() => tanggalTerpilih = tanggal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tambah Pengeluaran",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: jumlahController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Jumlah (Rp)"),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: kategoriTerpilih,
            hint: const Text("Pilih Kategori"),
            items:
                kategoriList.map((kategori) {
                  return DropdownMenuItem(
                    value: kategori,
                    child: Text(kategori),
                  );
                }).toList(),
            onChanged: (val) => setState(() => kategoriTerpilih = val),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: deskripsiController,
            decoration: const InputDecoration(labelText: "Deskripsi"),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Text(
                  tanggalTerpilih == null
                      ? "Tanggal: belum dipilih"
                      : "Tanggal: ${DateFormat('dd/MM/yyyy').format(tanggalTerpilih!)}",
                ),
              ),
              TextButton(
                onPressed: pilihTanggal,
                child: const Text("Pilih Tanggal"),
              ),
            ],
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: simpanPengeluaran,
              child: const Text("SIMPAN"),
            ),
          ),
        ],
      ),
    );
  }
}
