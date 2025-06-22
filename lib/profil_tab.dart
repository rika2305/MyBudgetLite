import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilTab extends StatelessWidget {
  const ProfilTab({super.key});

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          const SizedBox(height: 16),
          const Text(
            "Profil Pengguna",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(user?.email ?? '-', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
