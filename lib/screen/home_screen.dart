import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/theme_provider.dart';
import 'animals_screen.dart';
import 'report_case_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';
import 'PetCarescreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  late AnimationController _controller;
  late Animation<double> _fade;

  final pages = const [
    HomeDashboard(),
    ReportCaseScreen(),
    AnimalsScreen(),
    MapScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  void _onNav(int i) {
    setState(() => _index = i);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(opacity: _fade, child: pages[_index]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: _onNav,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_rounded),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_rounded),
            label: 'Animals',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/* ================= DASHBOARD ================= */

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* ---------- HEADER ---------- */
            Row(
              children: [
                const Text(
                  "Welcome 🐾",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
                  onPressed: () => context.read<ThemeProvider>().toggleTheme(),
                ),
              ],
            ),

            const SizedBox(height: 6),
            const Text(
              "Care, rescue & protect animals\nwith love and technology",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            _ActionCard(
              icon: Icons.favorite,
              title: "Pet Care",
              subtitle: "Health, food & welfare",
              color: Colors.purple,
              onTap: () => _go(context, const PetCareScreen()),
            ),

            _ActionCard(
              icon: Icons.report,
              title: "Report Animal",
              subtitle: "Injured or stray animal",
              color: Colors.redAccent,
              onTap: () => _go(context, const ReportCaseScreen()),
            ),

            _ActionCard(
              icon: Icons.map,
              title: "Animal Map",
              subtitle: "Nearby rescue cases",
              color: Colors.blue,
              onTap: () => _go(context, const MapScreen()),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= ACTION CARD ================= */

class _ActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          transform: _hover ? (Matrix4.identity()..translate(0, -4)) : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.25),
                blurRadius: _hover ? 22 : 12,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: widget.color.withValues(alpha: 0.15),
                child: Icon(widget.icon, color: widget.color, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
