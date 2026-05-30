import 'package:flutter/material.dart';
// If url_launcher is in pubspec.yaml, uncomment these:
// import 'package:url_launcher/url_launcher.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  bool _sosPressed = false;

  // Emergency contacts — loaded from Firestore in full integration
  final List<Map<String, String>> _contacts = [
    {'name': 'Mum',           'phone': '+60123456789', 'initial': 'M', 'relation': 'Mother'},
    {'name': 'Roommate Zue', 'phone': '+60112345678', 'initial': 'H', 'relation': 'Roommate'},
  ];

  // Simulates a phone call — replace with url_launcher in real app
  void _callContact(String name, String phone) {
    // ── REAL CALL CODE (uncomment when url_launcher is added) ──
    // final uri = Uri.parse('tel:$phone');
    // launchUrl(uri);

    // ── Placeholder for now ────────────────────────────────────
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.phone, color: Color(0xFF1D9E75)),
            const SizedBox(width: 8),
            Text('Calling $name'),
          ],
        ),
        content: Text('Dialling $phone...\n\n(Add url_launcher to pubspec.yaml to make real calls)'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('End call'),
          ),
        ],
      ),
    );
  }

  void _pressSOS() {
    setState(() => _sosPressed = true);

    // Alert all contacts
    for (final c in _contacts) {
      // TODO: send push notification via FCM to contacts
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFFCEBEB),
        title: const Row(
          children: [
            Icon(Icons.sos, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('SOS Sent!', style: TextStyle(color: Colors.red)),
          ],
        ),
        content: const Text(
          'Your emergency contacts have been alerted.\n\nStay calm — help is on the way.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() => _sosPressed = false);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('OK, I\'m safe now'),
          ),
        ],
      ),
    );
  }

  void _showTip(String title, String content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(content,
                style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE35D9C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addContact() {
    final nameCtrl  = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add emergency contact',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone number',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name  = nameCtrl.text.trim();
              final phone = phoneCtrl.text.trim();
              if (name.isNotEmpty && phone.isNotEmpty) {
                setState(() {
                  _contacts.add({
                    'name': name,
                    'phone': phone,
                    'initial': name[0].toUpperCase(),
                    'relation': 'Contact',
                  });
                  // TODO: SosRepository.addContact()
                });
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE35D9C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA32D2D),
        foregroundColor: Colors.white,
        title: const Text(
          'Emergency Help',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ── BIG SOS BUTTON ──────────────────────────────────────
            GestureDetector(
              onTap: _pressSOS,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: _sosPressed
                      ? Colors.red
                      : const Color(0xFFFCEBEB),
                  border: Border.all(
                    color: const Color(0xFFE24B4A),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: _sosPressed
                            ? Colors.white
                            : const Color(0xFFE24B4A),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.sos,
                        size: 38,
                        color: _sosPressed
                            ? const Color(0xFFE24B4A)
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'SOS — press for help',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _sosPressed
                            ? Colors.white
                            : const Color(0xFFA32D2D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Alerts your emergency contacts',
                      style: TextStyle(
                        fontSize: 12,
                        color: _sosPressed
                            ? Colors.white70
                            : const Color(0xFFA32D2D),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── 4 ACTION CARDS ──────────────────────────────────────
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.3,
              children: [
                _actionCard(
                  icon: Icons.medication,
                  label: 'Take medicine',
                  sub: 'Pain reliever guide',
                  color: const Color(0xFFFAEEDA),
                  iconColor: const Color(0xFF854F0B),
                  onTap: () => _showTip(
                    'Pain reliever guide',
                    '💊 Ibuprofen (400mg) or Paracetamol (500mg) can relieve period cramps.\n\n'
                        '• Take with food to avoid stomach upset.\n'
                        '• Do not exceed the recommended dose.\n'
                        '• If pain is severe and unrelieved, please see a doctor.',
                  ),
                ),
                _actionCard(
                  icon: Icons.local_fire_department,
                  label: 'Heating pad',
                  sub: 'Cramp relief tips',
                  color: const Color(0xFFFCEBEB),
                  iconColor: const Color(0xFFA32D2D),
                  onTap: () => _showTip(
                    'Using a heating pad',
                    '🔥 Apply a heating pad or warm water bottle to your lower abdomen.\n\n'
                        '• Use medium heat — never hot enough to burn.\n'
                        '• Apply for 15–20 minutes at a time.\n'
                        '• A warm shower can also help relax muscles.',
                  ),
                ),
                _actionCard(
                  icon: Icons.phone,
                  label: 'Call clinic',
                  sub: 'UTM health centre',
                  color: const Color(0xFFE1F5EE),
                  iconColor: const Color(0xFF085041),
                  onTap: () => _callContact('UTM Health Centre', '+60139876543'),
                ),
                _actionCard(
                  icon: Icons.people,
                  label: 'My contacts',
                  sub: '${_contacts.length} saved',
                  color: const Color(0xFFEEEDFE),
                  iconColor: const Color(0xFF3C3489),
                  onTap: () {
                    // Scroll down to contacts section
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Scroll down to see your contacts.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── EMERGENCY CONTACTS ──────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'EMERGENCY CONTACTS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addContact,
                  icon: const Icon(Icons.add,
                      size: 18, color: Color(0xFFE35D9C)),
                  label: const Text(
                    'Add',
                    style: TextStyle(color: Color(0xFFE35D9C)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ..._contacts.map((c) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFFBEAF0),
                  child: Text(
                    c['initial']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE35D9C),
                    ),
                  ),
                ),
                title: Text(c['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(c['phone']!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Call button
                    GestureDetector(
                      onTap: () => _callContact(c['name']!, c['phone']!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1F5EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Call',
                          style: TextStyle(
                            color: Color(0xFF0F6E56),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Delete
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.red, size: 20),
                      onPressed: () {
                        setState(() => _contacts.remove(c));
                        // TODO: SosRepository.deleteContact()
                      },
                    ),
                  ],
                ),
              ),
            )),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String label,
    required String sub,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
            const SizedBox(height: 3),
            Text(sub,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: iconColor.withOpacity(0.7),
                    fontSize: 10)),
          ],
        ),
      ),
    );
  }
}