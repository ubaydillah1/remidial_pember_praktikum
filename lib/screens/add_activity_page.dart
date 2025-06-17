import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../models/activity_model.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final databaseRef = FirebaseDatabase.instance.ref("activities");
  final _formKey = GlobalKey<FormState>();

  String namaKegiatan = '';
  String deskripsi = '';
  String tanggal = '';
  String kategori = 'Kuliah';
  bool tanggalError = false;

  final kategoriList = ['Kuliah', 'Organisasi', 'Lainnya'];
  late TextEditingController _tanggalController;

  @override
  void initState() {
    super.initState();
    _tanggalController = TextEditingController(text: tanggal);
  }

  @override
  void dispose() {
    _tanggalController.dispose();
    super.dispose();
  }

  void _simpanKegiatan() {
    final isValidForm = _formKey.currentState!.validate();
    final isTanggalValid = tanggal.trim().isNotEmpty;

    setState(() {
      tanggalError = !isTanggalValid;
    });

    if (isValidForm && isTanggalValid) {
      final newRef = databaseRef.push();
      final newActivity = Activity(
        id: newRef.key!,
        namaKegiatan: namaKegiatan,
        deskripsi: deskripsi,
        tanggal: tanggal,
        kategori: kategori,
        foto: 'placeholder.png',
      );

      newRef
          .set(newActivity.toJson())
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Kegiatan berhasil disimpan!")),
            );
            Navigator.pop(context, true);
          })
          .catchError((error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Gagal menyimpan: $error")));
          });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        tanggal = DateFormat('yyyy-MM-dd').format(picked);
        _tanggalController.text = tanggal;
        tanggalError = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Tambah Data",
          style: TextStyle(
            color: Color(0xFF201E43),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    buildLabel("Nama Kegiatan :"),
                    buildBoxInput(
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Masukkan nama kegiatan',
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Wajib diisi'
                                    : null,
                        onChanged: (value) => namaKegiatan = value,
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildLabel("Kategori :"),
                    buildBoxInput(
                      child: DropdownButtonFormField<String>(
                        value: kategori,
                        dropdownColor: const Color(0xFF508C9B),
                        iconEnabledColor: Colors.white,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white),
                        items:
                            kategoriList.map((kat) {
                              return DropdownMenuItem(
                                value: kat,
                                child: Text(
                                  kat,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => kategori = value);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildLabel("Tanggal :"),
                    buildBoxInput(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _tanggalController,
                            style: const TextStyle(color: Colors.white),
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Pilih tanggal',
                              hintStyle: TextStyle(color: Colors.white70),
                            ),
                          ),
                          if (tanggalError)
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                "Tanggal wajib diisi",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildLabel("Deskripsi (Optional):"),
                    buildBoxInput(
                      minHeight: 80,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        minLines: 3,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Masukkan deskripsi',
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                        onChanged: (value) => deskripsi = value,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          buildLabel("Dokumentasi :"),
                          const SizedBox(height: 8),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF201E43),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/placeholder.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpanKegiatan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF201E43),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
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

  Widget buildBoxInput({required Widget child, double minHeight = 48}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: const Color(0xFF508C9B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
