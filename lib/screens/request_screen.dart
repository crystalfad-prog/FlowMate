import 'package:flutter/material.dart';

class _RequestItem {
  final String id;
  final String name;
  final String initials;
  final Color avatarColor;
  final String message;
  final String distance;
  final String time;
  final String itemType;
  final Color itemColor;
  bool accepted;
  bool ignored;

  _RequestItem({
    required this.id,
    required this.name,
    required this.initials,
    required this.avatarColor,
    required this.message,
    required this.distance,
    required this.time,
    required this.itemType,
    required this.itemColor,
    this.accepted = false,
    this.ignored = false,
  });
}

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  // Tab: 0 = Nearby, 1 = My Requests
  int _tab = 0;

  final List<_RequestItem> _nearby = [
    _RequestItem(
      id: '1',
      name: 'Mai',
      initials: 'M',
      avatarColor: const Color(0xFFEEEDFE),
      message: 'Need pads urgently at TAZ, Level 2 — anyone nearby?',
      distance: '50m away',
      time: '5 min ago',
      itemType: 'Pads',
      itemColor: Colors.pink,
    ),
    _RequestItem(
      id: '2',
      name: 'Illyana',
      initials: 'I',
      avatarColor: const Color(0xFFE1F5EE),
      message: 'Anyone has ibuprofen? Severe cramps at the PeTARY.',
      distance: '120m away',
      time: '12 min ago',
      itemType: 'Medicine',
      itemColor: Colors.orange,
    ),
    _RequestItem(
      id: '3',
      name: 'Risa',
      initials: 'R',
      avatarColor: const Color(0xFFFAEEDA),
      message: 'Need a heating pad for cramps — TAZ café area.',
      distance: '200m away',
      time: '20 min ago',
      itemType: 'Heating',
      itemColor: Colors.deepOrange,
    ),
  ];

  final List<_RequestItem> _myRequests = [];

  final TextEditingController _msgCtrl      = TextEditingController();
  final TextEditingController _locationCtrl = TextEditingController();
  String _selectedItem = 'Pads';

  @override
  void dispose() {
    _msgCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _acceptRequest(int index) {
    setState(() => _nearby[index].accepted = true);
    // TODO: RequestRepository.acceptRequest()
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You offered to help ${_nearby[index].name}!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _ignoreRequest(int index) {
    setState(() => _nearby[index].ignored = true);
  }

  void _showSubmitDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New request',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // What do you need?
              const Text('What do you need?',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['Pads', 'Medicine', 'Heating pad', 'Other']
                    .map((item) => ChoiceChip(
                  label: Text(item),
                  selected: _selectedItem == item,
                  onSelected: (_) =>
                      setState(() => _selectedItem = item),
                  selectedColor: const Color(0xFFE35D9C),
                  labelStyle: TextStyle(
                    color: _selectedItem == item
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ))
                    .toList(),
              ),
              const SizedBox(height: 14),

              // Message
              TextField(
                controller: _msgCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Describe your need',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // Location
              TextField(
                controller: _locationCtrl,
                decoration: InputDecoration(
                  labelText: 'Your location (e.g. Hostel B, Level 2)',
                  prefixIcon: const Icon(Icons.location_on,
                      color: Color(0xFFE35D9C)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final msg      = _msgCtrl.text.trim();
                    final location = _locationCtrl.text.trim();
                    if (msg.isEmpty || location.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    // TODO: RequestRepository.submitRequest()
                    setState(() {
                      _myRequests.add(_RequestItem(
                        id: DateTime.now().toString(),
                        name: 'Me',
                        initials: 'M',
                        avatarColor: const Color(0xFFFBEAF0),
                        message: msg,
                        distance: 'My request',
                        time: 'Just now',
                        itemType: _selectedItem,
                        itemColor: Colors.pink,
                      ));
                    });
                    _msgCtrl.clear();
                    _locationCtrl.clear();
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Request posted!'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE35D9C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Post request',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D9E75),
        foregroundColor: Colors.white,
        title: const Text(
          'Nearby Requests',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Post a request',
            onPressed: _showSubmitDialog,
          ),
        ],
      ),
      body: Column(
        children: [

          // Location banner
          Container(
            width: double.infinity,
            color: const Color(0xFF1D9E75),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Near TAZ College, UNIMAS',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          // Tab bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE1F5EE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  _tabBtn('Nearby', 0),
                  _tabBtn('My Requests', 1),
                ],
              ),
            ),
          ),

          // List
          Expanded(
            child: _tab == 0 ? _buildNearbyList() : _buildMyList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showSubmitDialog,
        backgroundColor: const Color(0xFF1D9E75),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Post request',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _tabBtn(String label, int index) {
    final selected = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1D9E75) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF1D9E75),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyList() {
    final visible = _nearby.where((r) => !r.ignored).toList();
    if (visible.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off, size: 56, color: Colors.grey),
            SizedBox(height: 12),
            Text('No open requests nearby.',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: visible.length,
      itemBuilder: (_, i) => _requestCard(visible[i], i),
    );
  }

  Widget _buildMyList() {
    if (_myRequests.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox, size: 56, color: Colors.grey),
            SizedBox(height: 12),
            Text("You haven't posted any requests yet.",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: _myRequests.length,
      itemBuilder: (_, i) {
        final r = _myRequests[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: r.avatarColor,
              child: Text(r.initials,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(r.message,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${r.itemType} · ${r.time}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Open',
                  style: TextStyle(
                      color: Colors.orange, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }

  Widget _requestCard(_RequestItem r, int i) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: r.avatarColor,
                  child: Text(r.initials,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: r.itemColor)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.message,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(
                        '${r.name} · ${r.distance} · ${r.time}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: r.itemColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(r.itemType,
                      style: TextStyle(
                          color: r.itemColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Accept / Ignore buttons
            r.accepted
                ? Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  '✓ You offered to help',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            )
                : Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _acceptRequest(
                        _nearby.indexOf(r)),
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('I can help'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE1F5EE),
                      foregroundColor: const Color(0xFF0F6E56),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _ignoreRequest(_nearby.indexOf(r)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Skip'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
