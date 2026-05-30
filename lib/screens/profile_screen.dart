import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  // ── helpers ──────────────────────────────────────────────────────────────

  void _showEditProfile() {
    final nameCtrl = TextEditingController(text: "FlowMate User");
    final emailCtrl = TextEditingController(text: user?.email ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BottomSheet(
        title: "Edit Profile",
        icon: Icons.person,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _InputField(label: "Display Name", controller: nameCtrl),
              const SizedBox(height: 12),
              _InputField(
                  label: "Email", controller: emailCtrl, enabled: false),
              const SizedBox(height: 20),
              _PinkButton(
                label: "Save Changes",
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Profile updated!")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCycleSettings() {
    int cycleLength = 28;
    int periodDuration = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setInner) => _BottomSheet(
          title: "Cycle Settings",
          icon: Icons.calendar_month,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SliderTile(
                label: "Cycle Length",
                value: cycleLength.toDouble(),
                min: 21,
                max: 40,
                unit: "days",
                onChanged: (v) => setInner(() => cycleLength = v.round()),
              ),
              const SizedBox(height: 12),
              _SliderTile(
                label: "Period Duration",
                value: periodDuration.toDouble(),
                min: 2,
                max: 10,
                unit: "days",
                onChanged: (v) =>
                    setInner(() => periodDuration = v.round()),
              ),
              const SizedBox(height: 20),
              _PinkButton(
                label: "Save Settings",
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Cycle: $cycleLength days, Period: $periodDuration days saved!"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotifications() {
    bool periodReminder = true;
    bool fertileReminder = false;
    bool medicineReminder = true;
    bool sosAlert = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setInner) => _BottomSheet(
          title: "Notifications",
          icon: Icons.notifications,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ToggleTile(
                label: "Period Reminders",
                subtitle: "Notify 2 days before period",
                value: periodReminder,
                onChanged: (v) => setInner(() => periodReminder = v),
              ),
              _ToggleTile(
                label: "Fertile Window Alerts",
                subtitle: "Notify when fertile window starts",
                value: fertileReminder,
                onChanged: (v) => setInner(() => fertileReminder = v),
              ),
              _ToggleTile(
                label: "Medicine Reminder",
                subtitle: "Daily reminder for pain relievers",
                value: medicineReminder,
                onChanged: (v) => setInner(() => medicineReminder = v),
              ),
              _ToggleTile(
                label: "SOS Alert Notifications",
                subtitle: "Alerts from nearby requests",
                value: sosAlert,
                onChanged: (v) => setInner(() => sosAlert = v),
              ),
              const SizedBox(height: 20),
              _PinkButton(
                label: "Save Preferences",
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Notification preferences saved!")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSosContacts() {
    final contacts = [
      {"name": "Mum", "phone": "+60 12-345 6789"},
      {"name": "Best Friend", "phone": "+60 11-234 5678"},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setInner) => _BottomSheet(
          title: "SOS Contacts",
          icon: Icons.phone,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...contacts.asMap().entries.map((entry) {
                final c = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF4F7),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE45D9E).withOpacity(0.3)),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFE45D9E),
                      child: Text(
                        c["name"]![0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(c["name"]!,
                        style:
                        const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(c["phone"]!),
                    trailing: IconButton(
                      icon:
                      const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setInner(() => contacts.removeAt(entry.key));
                      },
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _addContactDialog(ctx, contacts, setInner),
                icon: const Icon(Icons.add, color: Color(0xFFE45D9E)),
                label: const Text("Add Contact",
                    style: TextStyle(color: Color(0xFFE45D9E))),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE45D9E)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 12),
              _PinkButton(
                label: "Save Contacts",
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("SOS contacts saved!")),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addContactDialog(
      BuildContext ctx,
      List<Map<String, String>> contacts,
      StateSetter setInner,
      ) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Add SOS Contact"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                  labelText: "Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE45D9E)),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && phoneCtrl.text.isNotEmpty) {
                setInner(() => contacts
                    .add({"name": nameCtrl.text, "phone": phoneCtrl.text}));
                Navigator.pop(ctx);
              }
            },
            child: const Text("Add",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Log Out"),
        content:
        const Text("Are you sure you want to log out of FlowMate?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text("Log Out",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final String email = user?.email ?? "No Email";
    final String initial =
    email.isNotEmpty ? email[0].toUpperCase() : "U";

    return Scaffold(
      backgroundColor: const Color(0xFFFDF4F7),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 70, bottom: 30),
              decoration: const BoxDecoration(
                color: Color(0xFFE45D9E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color(0xFFF5A8C8),
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "FlowMate User",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _StatColumn(value: "6", label: "Cycles Logged"),
                      SizedBox(
                          height: 50,
                          child: VerticalDivider(color: Colors.white)),
                      _StatColumn(value: "28d", label: "Avg Cycle"),
                      SizedBox(
                          height: 50,
                          child: VerticalDivider(color: Colors.white)),
                      _StatColumn(value: "3", label: "Requests Helped"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Menu Card ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    _MenuTile(
                      icon: Icons.person,
                      title: "Edit Profile",
                      subtitle: "Name, email, photo",
                      onTap: _showEditProfile,
                    ),
                    const Divider(height: 1),
                    _MenuTile(
                      icon: Icons.calendar_month,
                      title: "Cycle Settings",
                      subtitle: "Length, duration",
                      onTap: _showCycleSettings,
                    ),
                    const Divider(height: 1),
                    _MenuTile(
                      icon: Icons.notifications,
                      title: "Notifications",
                      subtitle: "Reminders and alerts",
                      onTap: _showNotifications,
                    ),
                    const Divider(height: 1),
                    _MenuTile(
                      icon: Icons.phone,
                      title: "SOS Contacts",
                      subtitle: "Emergency contacts",
                      onTap: _showSosContacts,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        "Logout",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: _confirmLogout,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Reusable widgets ───────────────────────────────────────────────────────

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;
  const _StatColumn({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _BottomSheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _BottomSheet(
      {required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE45D9E),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;

  const _InputField(
      {required this.label,
        required this.controller,
        this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !enabled,
        fillColor: Colors.grey[100],
      ),
    );
  }
}

class _SliderTile extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final ValueChanged<double> onChanged;

  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE45D9E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${value.round()} $unit",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          activeColor: const Color(0xFFE45D9E),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey)),
      value: value,
      activeColor: const Color(0xFFE45D9E),
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}

class _PinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PinkButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE45D9E),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onTap,
        child: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}