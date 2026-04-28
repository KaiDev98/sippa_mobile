import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tambah_jadwal_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static const Color primary = Color(0xFFAF101A);
  static const Color primaryContainer = Color(0xFFD32F2F);
  static const Color surfaceContainerLowest = Colors.white;
  static const Color surfaceContainerHigh = Color(0xFFEAE7E7);
  static const Color surfaceVariant = Color(0xFFE5E2E1);
  static const Color onSurface = Color(0xFF1B1C1C);
  static const Color onSurfaceVariant = Color(0xFF5B403D);
  static const Color outlineVariant = Color(0xFFE4BEBA);

  String _selectedDay = 'Semua';
  final List<String> _days = ['Semua', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  // Data jadwal
  final List<Map<String, dynamic>> _jadwalHariIni = [
    {
      'time': '06:00',
      'repeat': 'Setiap Hari',
      'pakan': '200g',
      'air': '500ml',
      'days': ['S', 'S', 'R', 'K', 'J', 'S', 'M'],
      'activeDays': [true, true, true, true, true, true, true],
      'isActive': true,
    },
    {
      'time': '12:00',
      'repeat': 'Setiap Hari',
      'pakan': '150g',
      'air': '400ml',
      'days': ['S', 'S', 'R', 'K', 'J', 'S', 'M'],
      'activeDays': [true, true, true, true, true, true, true],
      'isActive': true,
    },
  ];

  final List<Map<String, dynamic>> _jadwalBesok = [
    {
      'time': '08:00',
      'repeat': 'Khusus',
      'pakan': '300g',
      'air': '600ml',
      'days': ['S', 'S', 'R', 'K', 'J', 'S', 'M'],
      'activeDays': [false, true, false, false, false, false, false],
      'isActive': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: Column(
        children: [
          _buildTopAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildSummaryStrip(),
                  const SizedBox(height: 24),
                  _buildDayFilter(),
                  const SizedBox(height: 24),
                  _buildJadwalList(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  // ─────────────────────────────────────────────
  // TOP APP BAR
  // ─────────────────────────────────────────────
  Widget _buildTopAppBar() {
    return Container(
      color: primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 24, // Padding kiri disesuaikan karena arrow back dihapus
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          Text(
            'Jadwal Pakan',
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SUMMARY STRIP
  // ─────────────────────────────────────────────
  Widget _buildSummaryStrip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [primary, primaryContainer],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.25),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Text(
              '5 Jadwal Aktif Hari Ini',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // DAY FILTER
  // ─────────────────────────────────────────────
  Widget _buildDayFilter() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final isSelected = _selectedDay == _days[i];
          return GestureDetector(
            onTap: () => setState(() => _selectedDay = _days[i]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? primary : surfaceContainerLowest,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isSelected ? primary : outlineVariant,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primary.withOpacity(0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        )
                      ]
                    : [],
              ),
              child: Text(
                _days[i],
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : primary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // JADWAL LIST
  // ─────────────────────────────────────────────
  Widget _buildJadwalList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Jadwal Hari Ini
          ..._jadwalHariIni.asMap().entries.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildJadwalCard(e.value, false, e.key),
            );
          }),

          // Separator Besok
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Jadwal Besok',
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: onSurface,
                letterSpacing: -0.5,
              ),
            ),
          ),

          // Jadwal Besok
          ..._jadwalBesok.asMap().entries.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildJadwalCard(e.value, true, e.key),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildJadwalCard(Map<String, dynamic> jadwal, bool isBesok, int index) {
    final bool isActive = jadwal['isActive'] as bool;
    final List<String> days = List<String>.from(jadwal['days']);
    final List<bool> activeDays = List<bool>.from(jadwal['activeDays']);

    return Opacity(
      opacity: isBesok ? 0.85 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Left accent bar
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  color: isActive ? primary : surfaceVariant,
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time + Badge + Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time & Badge
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  jadwal['time'],
                                  style: GoogleFonts.manrope(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    color: isActive ? primary : onSurfaceVariant,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: isActive ? primary : outlineVariant,
                                    ),
                                  ),
                                  child: Text(
                                    jadwal['repeat'],
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: isActive ? primary : onSurfaceVariant,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Toggle + More
                        Row(
                          children: [
                            // Custom Toggle
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isBesok) {
                                    _jadwalBesok[index]['isActive'] = !isActive;
                                  } else {
                                    _jadwalHariIni[index]['isActive'] = !isActive;
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: 44,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: isActive ? primary : surfaceVariant,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: AnimatedAlign(
                                  duration: const Duration(milliseconds: 250),
                                  alignment: isActive
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.all(3),
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.more_vert_rounded,
                              color: onSurfaceVariant,
                              size: 22,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Pakan & Air Info
                    Row(
                      children: [
                        _infoChip(Icons.scale_rounded, 'Pakan: ${jadwal['pakan']}'),
                        const SizedBox(width: 20),
                        _infoChip(Icons.water_drop_rounded, 'Air: ${jadwal['air']}'),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Day Pills
                    Row(
                      children: List.generate(days.length, (i) {
                        final active = activeDays[i];
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: active ? primary : surfaceContainerHigh,
                              shape: BoxShape.circle,
                              border: active
                                  ? null
                                  : Border.all(color: outlineVariant),
                            ),
                            child: Center(
                              child: Text(
                                days[i],
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: active ? Colors.white : onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: onSurfaceVariant),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // FAB
  // ─────────────────────────────────────────────
  Widget _buildFAB() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _navigateToTambahJadwal(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: surfaceContainerLowest,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: primary.withOpacity(0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              'Tambah Jadwal',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton(
          onPressed: () => _navigateToTambahJadwal(),
          backgroundColor: primary,
          elevation: 6,
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
        ),
      ],
    );
  }

  void _navigateToTambahJadwal() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const TambahJadwalScreen(),
      ),
    );
  }
}