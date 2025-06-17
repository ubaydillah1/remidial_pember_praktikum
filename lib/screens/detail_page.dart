import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/activity_model.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  void _hapusData(BuildContext context, Activity activity) {
    final ref = FirebaseDatabase.instance.ref("activities/${activity.id}");
    ref
        .remove()
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Kegiatan berhasil dihapus")),
          );
          Navigator.pop(context);
        })
        .catchError((error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Gagal menghapus: $error")));
        });
  }

  @override
  Widget build(BuildContext context) {
    final Activity activity =
        ModalRoute.of(context)!.settings.arguments as Activity;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Detail Tugas",
          style: TextStyle(
            color: Color(0xFF201E43),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabel("Nama Kegiatan :"),
            buildBox(activity.namaKegiatan),
            const SizedBox(height: 12),
            buildLabel("Kategori :"),
            buildBox(activity.kategori),
            const SizedBox(height: 12),
            buildLabel("Tanggal :"),
            buildBox(activity.tanggal),
            const SizedBox(height: 12),
            buildLabel("Deskripsi :"),
            buildBox(activity.deskripsi, minHeight: 80),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  buildLabel("Dokumentasi :"),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/placeholder.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _hapusData(context, activity),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF201E43),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Hapus",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Color(0xFF201E43),
      ),
    );
  }

  Widget buildBox(String text, {double minHeight = 48}) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF508C9B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
