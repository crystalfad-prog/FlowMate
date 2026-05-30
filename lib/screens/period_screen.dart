import 'package:flutter/material.dart';

class PeriodScreen extends StatefulWidget {
  const PeriodScreen({super.key});

  @override
  State<PeriodScreen> createState() => _PeriodScreenState();
}

class _PeriodScreenState extends State<PeriodScreen> {
  // Currently selected flow level
  String _selectedFlow = 'Light';

  // Toggleable symptoms
  final Map<String, bool> _symptoms = {
    'Cramps': false,
    'Fatigue': false,
    'Bloating': false,
    'Headache': false,
    'Nausea': false,
    'Mood low': false,
  };

  final TextEditingController _notesCtrl = TextEditingController();

  // Dummy history — replace with Firestore data later
  final List<Map<String, String>> _history = [
    {'date': '4 – 8 May 2025', 'flow': 'Moderate', 'days': '5 days'},
    {'date': '7 – 11 Apr 2025', 'flow': 'Heavy',    'days': '5 days'},
    {'date': '10 – 14 Mar 2025','flow': 'Light',    'days': '5 days'},
  ];

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  void _saveLog() {
    final selected = _symptoms.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    // TODO: call PeriodRepository.addCycle() here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Saved! Flow: $_selectedFlow'
              '${selected.isNotEmpty ? " · ${selected.join(", ")}" : ""}',
        ),
        backgroundColor: Colors.pink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE35D9C),
        foregroundColor: Colors.white,
        title: const Text(
          'Period Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Cycle summary chips ──────────────────────────────────
            Row(
              children: [
                _statChip('Cycle day', '20'),
                const SizedBox(width: 10),
                _statChip('Next period', '8 days'),
                const SizedBox(width: 10),
                _statChip('Avg length', '28d'),
              ],
            ),
            const SizedBox(height: 20),

            // ── Log today card ───────────────────────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'How is your flow today?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 12),

                  // Flow level chips
                  Wrap(
                    spacing: 8,
                    children: ['None', 'Spotting', 'Light', 'Moderate', 'Heavy']
                        .map((level) => GestureDetector(
                      onTap: () => setState(() => _selectedFlow = level),
                      child: Chip(
                        label: Text(level),
                        backgroundColor: _selectedFlow == level
                            ? const Color(0xFFE35D9C)
                            : const Color(0xFFFBEAF0),
                        labelStyle: TextStyle(
                          color: _selectedFlow == level
                              ? Colors.white
                              : const Color(0xFFE35D9C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Symptoms',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 10),

                  // Symptom toggles
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _symptoms.keys.map((sym) {
                      final selected = _symptoms[sym]!;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _symptoms[sym] = !selected),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFE35D9C)
                                : const Color(0xFFFBEAF0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            sym,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFFE35D9C),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Notes
                  TextField(
                    controller: _notesCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Add a note (optional)...',
                      filled: true,
                      fillColor: const Color(0xFFFDF4F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveLog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE35D9C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Save today's log",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── History ──────────────────────────────────────────────
            const Text(
              'CYCLE HISTORY',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            ..._history.map(
                  (h) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBEAF0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.water_drop,
                        color: Color(0xFFE35D9C)),
                  ),
                  title: Text(
                    h['date']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Flow: ${h['flow']} · ${h['days']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      // TODO: delete from Firestore
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cycle deleted')),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _statChip(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE35D9C),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}