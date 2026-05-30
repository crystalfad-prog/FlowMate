import 'package:flutter/material.dart';
import 'period_screen.dart';
import 'essentials_screen.dart';
import 'request_screen.dart';
import 'sos_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                          children: const [
                            Text(
                              "Good Morning, Fad 👋",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Saturday, 30 May 2025",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),

                        // Avatar — tappable to go to profile
                        GestureDetector(
                          onTap: () {
                            // TODO: Navigator.push to ProfileScreen
                          },
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white24,
                            child: Text(
                              "F",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Cycle summary card — tappable to Period screen
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PeriodScreen(),
                          ),
                        );
                      },
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
                                  "Next period in",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "8 days",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Cycle day 20 of 28",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),

                            // Cycle ring
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  "20\nDay",
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
                    "FEATURES",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ── FEATURE CARDS GRID ─────────────────────────────────────
              // Each card now calls Navigator.push to its own screen.
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.2,
                children: [

                  // 🌸 PERIOD TRACKER
                  _FeatureCard(
                    icon: Icons.water_drop,
                    title: "Period Tracker",
                    subtitle: "Log & track cycle",
                    color: Colors.pink,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PeriodScreen(),
                      ),
                    ),
                  ),

                  // 🧴 ESSENTIALS
                  _FeatureCard(
                    icon: Icons.shopping_bag,
                    title: "Essentials",
                    subtitle: "Manage supplies",
                    color: Colors.deepPurple,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EssentialsScreen(),
                      ),
                    ),
                  ),

                  // 🚨 NEARBY REQUEST
                  _FeatureCard(
                    icon: Icons.location_on,
                    title: "Nearby Request",
                    subtitle: "Get campus help",
                    color: Colors.green,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RequestScreen(),
                      ),
                    ),
                  ),

                  // 🆘 SOS
                  _FeatureCard(
                    icon: Icons.sos,
                    title: "SOS",
                    subtitle: "Emergency help",
                    color: Colors.red,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SosScreen(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── ESSENTIAL STATUS LABEL ─────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ESSENTIAL STATUS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ── ESSENTIAL STATUS CARD ──────────────────────────────────
              // Tapping any row takes you to the Essentials screen.
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      _StatusRow(
                        icon: Icons.water_drop,
                        title: "Pads",
                        status: "2 left",
                        color: Colors.orange,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EssentialsScreen(),
                          ),
                        ),
                      ),

                      const Divider(),

                      _StatusRow(
                        icon: Icons.medication,
                        title: "Pain Reliever",
                        status: "5 left",
                        color: Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EssentialsScreen(),
                          ),
                        ),
                      ),

                      const Divider(),

                      _StatusRow(
                        icon: Icons.local_fire_department,
                        title: "Heating Pad",
                        status: "OK",
                        color: Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EssentialsScreen(),
                          ),
                        ),
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

// ══════════════════════════════════════════════════════════════
//  PRIVATE WIDGETS
// ══════════════════════════════════════════════════════════════

/// Feature card — GestureDetector wraps the whole card so
/// the entire surface area is tappable, not just the icon.
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
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Status row — InkWell gives a ripple effect on tap.
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
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 18),
          ],
        ),
      ),
    );
  }
}
