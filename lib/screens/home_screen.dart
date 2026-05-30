import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'period_screen.dart';
import 'essentials_screen.dart';
import 'request_screen.dart';
import 'sos_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ── Greeting based on time of day ──────────────────────────────────────
  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  // ── Real formatted date ────────────────────────────────────────────────
  String _formattedDate() {
    final now = DateTime.now();
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Read the logged-in user's display name from Firebase Auth
    final user = FirebaseAuth.instance.currentUser;
    final fullName = user?.displayName ?? user?.email ?? 'User';

    // First name only for the greeting (e.g. "Siti Aishah" → "Siti")
    final firstName = fullName.split(' ').first;

    // Avatar initial
    final initial = firstName.isNotEmpty ? firstName[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: const Color(0xFFFDF4F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // ── HEADER ─────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFE35D9C),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [

                    // Greeting row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_greeting()}, $firstName 👋',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _formattedDate(),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),

                        // Avatar — shows user's initial
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white24,
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Cycle summary card
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PeriodScreen()),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Next period in',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '8 days',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Cycle day 20 of 28',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 4),
                              ),
                              child: const Center(
                                child: Text(
                                  '20\nDay',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── FEATURES LABEL ─────────────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'FEATURES',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ── FEATURE CARDS ──────────────────────────────────────────
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.2,
                children: [
                  _FeatureCard(
                    icon: Icons.water_drop,
                    title: 'Period Tracker',
                    subtitle: 'Log & track cycle',
                    color: Colors.pink,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const PeriodScreen())),
                  ),
                  _FeatureCard(
                    icon: Icons.shopping_bag,
                    title: 'Essentials',
                    subtitle: 'Manage supplies',
                    color: Colors.deepPurple,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const EssentialsScreen())),
                  ),
                  _FeatureCard(
                    icon: Icons.location_on,
                    title: 'Nearby Request',
                    subtitle: 'Get campus help',
                    color: Colors.green,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const RequestScreen())),
                  ),
                  _FeatureCard(
                    icon: Icons.sos,
                    title: 'SOS',
                    subtitle: 'Emergency help',
                    color: Colors.red,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const SosScreen())),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── ESSENTIAL STATUS ───────────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ESSENTIAL STATUS',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _StatusRow(
                        icon: Icons.water_drop,
                        title: 'Pads',
                        status: '2 left',
                        color: Colors.orange,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const EssentialsScreen())),
                      ),
                      const Divider(),
                      _StatusRow(
                        icon: Icons.medication,
                        title: 'Pain Reliever',
                        status: '5 left',
                        color: Colors.green,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const EssentialsScreen())),
                      ),
                      const Divider(),
                      _StatusRow(
                        icon: Icons.local_fire_department,
                        title: 'Heating Pad',
                        status: 'OK',
                        color: Colors.green,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                                builder: (_) => const EssentialsScreen())),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable widgets ───────────────────────────────────────────────────────

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 10),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style:
                  const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;
  final Color color;
  final VoidCallback onTap;

  const _StatusRow({
    required this.icon,
    required this.title,
    required this.status,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(status,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right,
                color: Colors.grey.shade400, size: 18),
          ],
        ),
      ),
    );
  }
}
