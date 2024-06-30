import 'package:flutter/material.dart';
import 'history.dart';
import 'classification.dart';
import 'profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Widget halaman = const Classification();
  int tombol = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: halaman,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            switch (index) {
              case 0:
                halaman = const History();
                tombol = 0;
                break;
              case 1:
                halaman = const Classification();
                tombol = 1;
                break;
              case 2:
                halaman = const Profile();
                tombol = 2;
                break;
              default:
            }
          });
        },
        backgroundColor: Colors.orange,
        indicatorColor: Colors.white,
        selectedIndex: tombol,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.history_outlined, color: Colors.black),
            selectedIcon: Icon(Icons.history_outlined, color: Colors.orange),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined, color: Colors.black),
            selectedIcon: Icon(Icons.camera_alt_outlined, color: Colors.orange),
            label: 'Cek Kucing',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_2_outlined, color: Colors.black),
            selectedIcon: Icon(Icons.person_2_outlined, color: Colors.orange),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
