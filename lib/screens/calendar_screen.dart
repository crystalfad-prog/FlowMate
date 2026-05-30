import 'package:flutter/material.dart';

// ── Simple data model ──────────────────────────────────────────────────────

class _PeriodEntry {
  final DateTime start;
  final DateTime end;
  final String flow;
  final List<String> symptoms;

  const _PeriodEntry({
    required this.start,
    required this.end,
    required this.flow,
    required this.symptoms,
  });

  int get duration => end.difference(start).inDays + 1;

  bool contains(DateTime d) {
    final day = DateTime(d.year, d.month, d.day);
    return !day.isBefore(DateTime(start.year, start.month, start.day)) &&
        !day.isAfter(DateTime(end.year, end.month, end.day));
  }
}

// ── Screen ─────────────────────────────────────────────────────────────────

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final DateTime _today = DateTime.now();
  late DateTime _focused;

  static const int _cycleLen = 28;
  static const int _periodLen = 5;

  late List<_PeriodEntry> _entries;

  @override
  void initState() {
    super.initState();
    _focused = DateTime(_today.year, _today.month);
    _entries = [
      _PeriodEntry(
        start: _today.subtract(const Duration(days: 24)),
        end: _today.subtract(const Duration(days: 20)),
        flow: 'Moderate',
        symptoms: ['Cramps', 'Fatigue'],
      ),
      _PeriodEntry(
        start: _today.subtract(const Duration(days: 52)),
        end: _today.subtract(const Duration(days: 48)),
        flow: 'Heavy',
        symptoms: ['Cramps', 'Bloating'],
      ),
    ];
  }

  // ── Cycle calculations ───────────────────────────────────────────────────

  _PeriodEntry? get _lastEntry {
    if (_entries.isEmpty) return null;
    return _entries.reduce((a, b) => a.start.isAfter(b.start) ? a : b);
  }

  DateTime? get _nextStart {
    final last = _lastEntry;
    if (last == null) return null;
    return last.start.add(Duration(days: _cycleLen));
  }

  bool _isPeriod(DateTime d) => _entries.any((e) => e.contains(d));

  bool _isFertile(DateTime d) {
    final next = _nextStart;
    if (next == null) return false;
    for (int i = -1; i <= 2; i++) {
      final cycleStart = next.subtract(Duration(days: _cycleLen * i));
      final fs = cycleStart.add(const Duration(days: 9));
      final fe = cycleStart.add(const Duration(days: 16));
      final day = DateTime(d.year, d.month, d.day);
      if (!day.isBefore(fs) && !day.isAfter(fe)) return true;
    }
    return false;
  }

  bool _isPredicted(DateTime d) {
    final next = _nextStart;
    if (next == null) return false;
    final day = DateTime(d.year, d.month, d.day);
    final s = DateTime(next.year, next.month, next.day);
    final e = s.add(Duration(days: _periodLen - 1));
    return !day.isBefore(s) && !day.isAfter(e);
  }

  bool _isToday(DateTime d) =>
      d.year == _today.year && d.month == _today.month && d.day == _today.day;

  // ── Calendar grid helpers ────────────────────────────────────────────────

  List<DateTime?> get _days {
    final first = DateTime(_focused.year, _focused.month, 1);
    final last = DateTime(_focused.year, _focused.month + 1, 0);
    final blanks = first.weekday % 7;
    return [
      ...List<DateTime?>.filled(blanks, null),
      for (int d = 1; d <= last.day; d++)
        DateTime(_focused.year, _focused.month, d),
    ];
  }

  String get _monthLabel {
    const m = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December',
    ];
    return '${m[_focused.month - 1]} ${_focused.year}';
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final last = _lastEntry;
    final next = _nextStart;
    int? daysUntil;
    if (next != null) {
      daysUntil = next
          .difference(DateTime(_today.year, _today.month, _today.day))
          .inDays;
      if (daysUntil < 0) daysUntil = 0;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE45D9E),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Period calendar',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Next period banner ─────────────────────────────────────
            if (daysUntil != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE45D9E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.water_drop,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      daysUntil == 0
                          ? 'Period may start today'
                          : 'Next period in $daysUntil days',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

            // ── Calendar card ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Month navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_monthLabel,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                      Row(
                        children: [
                          _ArrowBtn(
                            icon: Icons.chevron_left,
                            onTap: () => setState(() => _focused =
                                DateTime(_focused.year, _focused.month - 1)),
                          ),
                          _ArrowBtn(
                            icon: Icons.chevron_right,
                            onTap: () => setState(() => _focused =
                                DateTime(_focused.year, _focused.month + 1)),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Weekday headers
                  Row(
                    children: ['S','M','T','W','T','F','S']
                        .map((h) => Expanded(
                      child: Center(
                        child: Text(h,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color(0xFF888888),
                            )),
                      ),
                    ))
                        .toList(),
                  ),

                  const SizedBox(height: 6),

                  // Day grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1,
                    ),
                    itemCount: _days.length,
                    itemBuilder: (_, i) {
                      final d = _days[i];
                      if (d == null) return const SizedBox();
                      return _DayCell(
                        date: d,
                        period: _isPeriod(d),
                        fertile: _isFertile(d),
                        predicted: _isPredicted(d),
                        today: _isToday(d),
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _LegendDot(color: Color(0xFFF5A8C8), label: 'Period'),
                      _LegendDot(color: Color(0xFF8FD6B4), label: 'Fertile'),
                      _LegendDot(
                          color: Color(0xFFAAAAAA),
                          label: 'Predicted',
                          dotted: true),
                      _LegendDot(color: Color(0xFFE45D9E), label: 'Today'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Last period summary ────────────────────────────────────
            if (last != null) ...[
              const Text('LAST PERIOD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF888888),
                    letterSpacing: 0.5,
                  )),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SummaryCol(
                        label: 'Duration', value: '${last.duration} days'),
                    _SummaryCol(label: 'Flow', value: last.flow),
                    _SummaryCol(
                      label: 'Symptoms',
                      value: last.symptoms.isEmpty
                          ? 'None'
                          : last.symptoms.join(', '),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Cycle history ──────────────────────────────────────────
            const Text('CYCLE HISTORY',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF888888),
                  letterSpacing: 0.5,
                )),
            const SizedBox(height: 8),

            ..._entries.reversed.map((e) => _HistoryTile(
              entry: e,
              onDelete: () => setState(() => _entries.remove(e)),
            )),

            const SizedBox(height: 16),

            // ── Log period button ──────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openLogSheet,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Log New Period',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE45D9E),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Log period sheet ─────────────────────────────────────────────────────

  void _openLogSheet() {
    DateTime? start;
    DateTime? end;
    String flow = 'Moderate';
    final List<String> picked = [];

    const flows = ['Light', 'Moderate', 'Heavy'];
    const allSymptoms = [
      'Cramps','Fatigue','Bloating',
      'Headache','Mood swings','Back pain','Nausea',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, set) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Log Period',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 18),

                  // Date pickers
                  Row(
                    children: [
                      Expanded(
                        child: _PickerTile(
                          label: 'Start Date',
                          date: start,
                          onTap: () async {
                            final d = await showDatePicker(
                              context: ctx,
                              initialDate: _today,
                              firstDate: DateTime(_today.year - 1),
                              lastDate: _today,
                              builder: (_, child) => Theme(
                                data: ThemeData().copyWith(
                                  colorScheme: const ColorScheme.light(
                                      primary: Color(0xFFE45D9E)),
                                ),
                                child: child!,
                              ),
                            );
                            if (d != null) set(() => start = d);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _PickerTile(
                          label: 'End Date',
                          date: end,
                          onTap: () async {
                            final d = await showDatePicker(
                              context: ctx,
                              initialDate: start ?? _today,
                              firstDate:
                              start ?? DateTime(_today.year - 1),
                              lastDate: _today,
                              builder: (_, child) => Theme(
                                data: ThemeData().copyWith(
                                  colorScheme: const ColorScheme.light(
                                      primary: Color(0xFFE45D9E)),
                                ),
                                child: child!,
                              ),
                            );
                            if (d != null) set(() => end = d);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Flow
                  const Text('Flow',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: flows.map((f) {
                      final sel = flow == f;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => set(() => flow = f),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: sel
                                  ? const Color(0xFFE45D9E)
                                  : const Color(0xFFFDF4F7),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: sel
                                    ? const Color(0xFFE45D9E)
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Center(
                              child: Text(f,
                                  style: TextStyle(
                                    color: sel ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  )),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Symptoms
                  const Text('Symptoms',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: allSymptoms.map((s) {
                      final sel = picked.contains(s);
                      return GestureDetector(
                        onTap: () => set(() =>
                        sel ? picked.remove(s) : picked.add(s)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: sel
                                ? const Color(0xFFE45D9E)
                                : const Color(0xFFFDF4F7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel
                                  ? const Color(0xFFE45D9E)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(s,
                              style: TextStyle(
                                color: sel ? Colors.white : Colors.black87,
                                fontSize: 13,
                              )),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE45D9E),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        if (start == null || end == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                Text('Please pick start and end dates')),
                          );
                          return;
                        }
                        setState(() => _entries.add(_PeriodEntry(
                          start: start!,
                          end: end!,
                          flow: flow,
                          symptoms: List.from(picked),
                        )));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Period logged ✓'),
                              backgroundColor: Color(0xFFE45D9E)),
                        );
                      },
                      child: const Text('Save Period',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable widgets ───────────────────────────────────────────────────────

class _ArrowBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ArrowBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(icon, size: 22, color: Colors.black87)),
  );
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool period, fertile, predicted, today;
  const _DayCell({
    required this.date,
    required this.period,
    required this.fertile,
    required this.predicted,
    required this.today,
  });

  @override
  Widget build(BuildContext context) {
    Color? bg;
    Color text = Colors.black87;
    bool dashed = false;

    if (today) {
      bg = const Color(0xFFE45D9E);
      text = Colors.white;
    } else if (period) {
      bg = const Color(0xFFF5A8C8);
    } else if (fertile) {
      bg = const Color(0xFF8FD6B4);
    } else if (predicted) {
      dashed = true;
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: dashed
          ? BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFAAAAAA), width: 1.5),
      )
          : BoxDecoration(shape: BoxShape.circle, color: bg),
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle(
            color: dashed ? Colors.black54 : text,
            fontSize: 12,
            fontWeight: today ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool dotted;
  const _LegendDot(
      {required this.color, required this.label, this.dotted = false});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 13,
        height: 13,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: dotted ? null : color,
          border: dotted ? Border.all(color: color, width: 1.5) : null,
        ),
      ),
      const SizedBox(width: 4),
      Text(label,
          style:
          const TextStyle(fontSize: 11, color: Colors.black54)),
    ],
  );
}

class _SummaryCol extends StatelessWidget {
  final String label, value;
  const _SummaryCol({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(
              fontSize: 12, color: Color(0xFF888888))),
      const SizedBox(height: 4),
      Text(value,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14)),
    ],
  );
}

class _HistoryTile extends StatelessWidget {
  final _PeriodEntry entry;
  final VoidCallback onDelete;
  const _HistoryTile({required this.entry, required this.onDelete});

  String _fmt(DateTime d) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${d.day} ${m[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)),
    child: ListTile(
      leading: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
            color: Color(0xFFFBEAF0), shape: BoxShape.circle),
        child: const Icon(Icons.water_drop, color: Color(0xFFE45D9E)),
      ),
      title: Text('${_fmt(entry.start)} – ${_fmt(entry.end)}',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Flow: ${entry.flow} · ${entry.duration} days'),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: onDelete,
      ),
    ),
  );
}

class _PickerTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  const _PickerTile(
      {required this.label, required this.date, required this.onTap});

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF4F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today,
              size: 16, color: Color(0xFFE45D9E)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: Colors.grey)),
              Text(
                date != null ? _fmt(date!) : 'Pick date',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
