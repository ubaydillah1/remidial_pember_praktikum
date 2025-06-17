import 'package:flutter/material.dart';
import 'package:uas/screens/add_activity_page.dart';
import 'package:uas/screens/detail_page.dart';
import 'screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Nama: Ubay Dillah
// NIM: 23-052
// Kelas: PEMBER B
// Nama Asprak: Kak Kukuh

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kegiatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        "/add": (context) => AddActivityPage(),
        "/detail": (context) => DetailPage(),
      },
    );
  }
}
