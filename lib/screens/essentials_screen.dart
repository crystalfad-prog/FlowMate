import 'package:flutter/material.dart';

// Simple local state model — replace with EssentialModel from Firestore later
class _Item {
  String name;
  IconData icon;
  Color color;
  int quantity;
  int threshold; // show warning below this

  _Item({
    required this.name,
    required this.icon,
    required this.color,
    required this.quantity,
    this.threshold = 3,
  });

  bool get isLow => quantity <= threshold;
}

class EssentialsScreen extends StatefulWidget {
  const EssentialsScreen({super.key});

  @override
  State<EssentialsScreen> createState() => _EssentialsScreenState();
}

class _EssentialsScreenState extends State<EssentialsScreen> {
  // Default items — loaded from Firestore in full integration
  final List<_Item> _items = [
    _Item(name: 'Pads',          icon: Icons.water_drop,           color: Colors.pink,       quantity: 2, threshold: 3),
    _Item(name: 'Pain reliever', icon: Icons.medication,           color: Colors.orange,     quantity: 5),
    _Item(name: 'Heating pad',   icon: Icons.local_fire_department,color: Colors.deepOrange, quantity: 1, threshold: 1),
    _Item(name: 'Tissues',       icon: Icons.wind_power,           color: Colors.deepPurple, quantity: 3),
  ];

  void _changeQty(int index, int delta) {
    setState(() {
      final newQty = _items[index].quantity + delta;
      if (newQty >= 0) {
        _items[index].quantity = newQty;
        // TODO: call EssentialRepository.updateEssential() here
      }
    });
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final qtyCtrl  = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add new item',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Item name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              final qty  = int.tryParse(qtyCtrl.text) ?? 1;
              if (name.isNotEmpty) {
                setState(() {
                  _items.add(_Item(
                    name: name,
                    icon: Icons.inventory_2,
                    color: Colors.teal,
                    quantity: qty,
                  ));
                  // TODO: EssentialRepository.addEssential()
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
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Count how many items are low
    final lowCount = _items.where((i) => i.isLow).length;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7F77DD),
        foregroundColor: Colors.white,
        title: const Text(
          'Essentials',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFF7F77DD),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ── Low stock warning banner ────────────────────────────
            if (lowCount > 0)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.orange),
                    const SizedBox(width: 10),
                    Text(
                      '$lowCount item${lowCount > 1 ? "s" : ""} running low!',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            // ── Items list ──────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final item = _items[i];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: item.isLow
                          ? Border.all(color: Colors.orange.shade300)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [

                        // Icon
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(item.icon,
                              color: item.color, size: 22),
                        ),
                        const SizedBox(width: 14),

                        // Name + badge
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              if (item.isLow)
                                const Text(
                                  'Running low',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // − qty + controls
                        Row(
                          children: [
                            _qtyBtn(
                              icon: Icons.remove,
                              onTap: () => _changeQty(i, -1),
                            ),
                            SizedBox(
                              width: 32,
                              child: Text(
                                '${item.quantity}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            _qtyBtn(
                              icon: Icons.add,
                              onTap: () => _changeQty(i, 1),
                            ),
                          ],
                        ),

                        const SizedBox(width: 8),

                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: item.isLow
                                ? Colors.orange.withOpacity(0.15)
                                : Colors.green.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            item.isLow ? 'Low' : 'OK',
                            style: TextStyle(
                              color: item.isLow
                                  ? Colors.orange
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        // Delete
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red, size: 20),
                          onPressed: () {
                            setState(() => _items.removeAt(i));
                            // TODO: EssentialRepository.deleteEssential()
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFFDF4F7),
        ),
        child: Icon(icon, size: 16, color: Colors.grey.shade700),
      ),
    );
  }
}
