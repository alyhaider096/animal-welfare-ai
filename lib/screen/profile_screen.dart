import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: (color ?? Colors.grey).withOpacity(0.15),
        child: Icon(icon, color: color ?? Colors.black87),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // 🐾 Avatar with glow
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withValues(alpha: 0.3),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 56,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 56),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              user?.displayName ?? "Animal Rescuer",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? "No email",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 32),

            tile(
              context,
              icon: Icons.history,
              title: "My Reports",
              color: Colors.orange,
            ),

            tile(
              context,
              icon: Icons.pets,
              title: "My Animals",
              color: Colors.green,
            ),

            tile(
              context,
              icon: Icons.settings,
              title: "Settings",
              color: Colors.blue,
            ),

            const Divider(height: 32),

            tile(
              context,
              icon: Icons.logout,
              title: "Logout",
              color: Colors.red,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                // AuthGate will auto redirect to Login
              },
            ),
          ],
        ),
      ),
    );
  }
}
