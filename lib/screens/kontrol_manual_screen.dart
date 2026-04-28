import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================
//  COLOR CONSTANTS
// ============================================================
const Color kPrimary = Color(0xFFAF101A);
const Color kPrimaryContainer = Color(0xFFD32F2F);
const Color kOnPrimary = Color(0xFFFFFFFF);
const Color kBackground = Color(0xFFFCF9F8);
const Color kSurfaceContainerLowest = Color(0xFFFFFFFF);
const Color kSurfaceContainerLow = Color(0xFFF6F3F2);
const Color kSurfaceContainer = Color(0xFFF0EDED);
const Color kSurfaceContainerHigh = Color(0xFFEAE7E7);
const Color kSurfaceContainerHighest = Color(0xFFE5E2E1);
const Color kSurfaceVariant = Color(0xFFE5E2E1);
const Color kOnSurface = Color(0xFF1B1C1C);
const Color kOnSurfaceVariant = Color(0xFF5B403D);
const Color kOutlineVariant = Color(0xFFE4BEBA);
const Color kOnPrimaryContainer = Color(0xFFFFF2F0);

// ============================================================
//  KONTROL MANUAL SCREEN
// ============================================================
class KontrolManualScreen extends StatefulWidget {
  const KontrolManualScreen({super.key});

  @override
  State<KontrolManualScreen> createState() => _KontrolManualScreenState();
}

class _KontrolManualScreenState extends State<KontrolManualScreen>
    with TickerProviderStateMixin {
  // --- State Pakan ---
  int _porsiPakan = 200;
  final List<int> _presetPakan = [100, 200, 300, 500];
  String _statusPakan = 'Siap';
  bool _isLoadingPakan = false;

  // --- State Air ---
  int _volumeAir = 150;
  bool _isLoadingAir = false;
  String _statusAir = 'Siap';

  // --- Animation Controllers ---
  late AnimationController _pakanBtnController;
  late AnimationController _airBtnController;
  late Animation<double> _pakanBtnScale;
  late Animation<double> _airBtnScale;

  @override
  void initState() {
    super.initState();
    _pakanBtnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _airBtnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _pakanBtnScale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pakanBtnController, curve: Curves.easeInOut),
    );
    _airBtnScale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _airBtnController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pakanBtnController.dispose();
    _airBtnController.dispose();
    super.dispose();
  }

  // --- Functions ---
  void _onBeriPakan() async {
    await _pakanBtnController.forward();
    await _pakanBtnController.reverse();
    setState(() {
      _isLoadingPakan = true;
      _statusPakan = 'Mengirim...';
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoadingPakan = false;
      _statusPakan = '✓ Berhasil dikirim';
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _statusPakan = 'Siap');
  }

  void _onBeriAir() async {
    await _airBtnController.forward();
    await _airBtnController.reverse();
    setState(() {
      _isLoadingAir = true;
      _statusAir = 'Mengirim...';
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoadingAir = false;
      _statusAir = '✓ Berhasil dikirim';
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _statusAir = 'Siap');
  }

  // --- Confirmation Bottom Sheet ---
  void _showConfirmation(
      String type, int amount, String unit, VoidCallback onConfirm) {
    final isAir = type == 'Air';
    final colorPrimary = isAir ? const Color(0xFF1976D2) : kPrimary;
    final colorContainer = isAir
        ? const Color(0xFF1976D2).withOpacity(0.1)
        : kPrimary.withOpacity(0.1);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding:
              const EdgeInsets.only(top: 16, bottom: 40, left: 32, right: 32),
          decoration: const BoxDecoration(
            color: kBackground, // surface
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 60,
                offset: Offset(0, -20),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 64,
                height: 6,
                decoration: BoxDecoration(
                  color: kSurfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              // Warning Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: colorPrimary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                'Konfirmasi Aksi',
                style: GoogleFonts.manrope(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: kOnSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              // Description
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: kOnSurfaceVariant,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                        text:
                            'Apakah Anda yakin ingin memberi ${type.toLowerCase()} sebanyak '),
                    TextSpan(
                      text: '$amount$unit',
                      style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: ' sekarang?'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup bottom sheet
                  onConfirm(); // Jalankan fungsi aksi
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 64),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  shadowColor: colorPrimary.withOpacity(0.5),
                ),
                child: Text(
                  'YA, BERI SEKARANG',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kOnSurfaceVariant,
                  minimumSize: const Size(double.infinity, 64),
                  side: BorderSide(
                    color: kOutlineVariant.withOpacity(0.6),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'BATAL',
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --------------------------------------------------------
  //  BUILD
  // --------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Column(
        children: [
          _buildTopAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              child: Column(
                children: [
                  _buildDeviceStatus(),
                  const SizedBox(height: 20),
                  _buildBeriPakanCard(),
                  const SizedBox(height: 20),
                  _buildBeriAirCard(),
                  const SizedBox(height: 16),
                  _buildRecentAction(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  //  TOP APP BAR
  // --------------------------------------------------------
  Widget _buildTopAppBar() {
    return Container(
      color: const Color(0xFFB71C1C),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 24, // Padding kiri diubah agar sejajar dengan layar lainnya
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          Text(
            'Kontrol Manual',
            style: GoogleFonts.manrope(
              fontSize: 22, // Disesuaikan sedikit agar seimbang dengan Home
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  //  DEVICE STATUS
  // --------------------------------------------------------
  Widget _buildDeviceStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: kSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Green indicator dot with glow
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ESP32 Terhubung',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kOnSurface,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.wifi_rounded,
                      size: 14, color: kOnSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    'Latensi: 3ms',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: kOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  //  BERI PAKAN CARD
  // --------------------------------------------------------
  Widget _buildBeriPakanCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.05),
            blurRadius: 48,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: kPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.restaurant_rounded,
                    color: kPrimary, size: 26),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beri Pakan Sekarang',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: kOnSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Stok: 3.2 kg (65%)',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: kOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Stock Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: 0.65,
              minHeight: 8,
              backgroundColor: kSurfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimary),
            ),
          ),

          const SizedBox(height: 20),

          // Quantity Selector
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kSurfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Minus Button
                _quantityButton(
                  icon: Icons.remove_rounded,
                  filled: false,
                  onTap: () {
                    if (_porsiPakan > 50) {
                      setState(() => _porsiPakan -= 10);
                    }
                  },
                ),
                // Value
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$_porsiPakan',
                            style: GoogleFonts.manrope(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: kPrimary,
                              letterSpacing: -1,
                            ),
                          ),
                          TextSpan(
                            text: ' g',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: kOnSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Plus Button
                _quantityButton(
                  icon: Icons.add_rounded,
                  filled: true,
                  onTap: () {
                    if (_porsiPakan < 500) {
                      setState(() => _porsiPakan += 10);
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Preset Buttons
          Row(
            children: _presetPakan.map((val) {
              final isSelected = _porsiPakan == val;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => setState(() => _porsiPakan = val),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? kOnPrimaryContainer
                            : kSurfaceContainer,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(
                                color: kPrimary.withOpacity(0.2), width: 2)
                            : null,
                      ),
                      child: Text(
                        '${val}g',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? kPrimary : kOnSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Beri Pakan Button
          ScaleTransition(
            scale: _pakanBtnScale,
            child: GestureDetector(
              onTap: _isLoadingPakan
                  ? null
                  : () => _showConfirmation(
                      'Pakan', _porsiPakan, 'g', _onBeriPakan),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kPrimary, kPrimaryContainer],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimary.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoadingPakan)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    else
                      const Icon(Icons.set_meal_rounded,
                          color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'BERI PAKAN',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Status
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                'Status: $_statusPakan',
                key: ValueKey(_statusPakan),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _statusPakan.contains('✓')
                      ? const Color(0xFF059669)
                      : kOnSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  //  BERI AIR CARD
  // --------------------------------------------------------
  Widget _buildBeriAirCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kSurfaceVariant.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 48,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.water_drop_rounded,
                    color: Color(0xFF1976D2), size: 26),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beri Air Sekarang',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: kOnSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Kapasitas: 80%',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: kOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Quantity Selector
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kSurfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Minus Button
                _quantityButton(
                  icon: Icons.remove_rounded,
                  filled: false,
                  onTap: () {
                    if (_volumeAir > 50) {
                      setState(() => _volumeAir -= 50);
                    }
                  },
                  isBlue: true,
                ),
                // Value
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '$_volumeAir',
                        style: GoogleFonts.manrope(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: kOnSurface,
                          letterSpacing: -1,
                        ),
                      ),
                      TextSpan(
                        text: ' ml',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: kOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Plus Button
                _quantityButton(
                  icon: Icons.add_rounded,
                  filled: false,
                  onTap: () {
                    if (_volumeAir < 1000) {
                      setState(() => _volumeAir += 50);
                    }
                  },
                  isBlue: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Beri Air Button
          ScaleTransition(
            scale: _airBtnScale,
            child: GestureDetector(
              onTap: _isLoadingAir
                  ? null
                  : () =>
                      _showConfirmation('Air', _volumeAir, 'ml', _onBeriAir),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 56,
                decoration: BoxDecoration(
                  color: _isLoadingAir
                      ? const Color(0xFF1976D2).withOpacity(0.8)
                      : const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1976D2).withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoadingAir)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    else
                      const Icon(Icons.water_drop_rounded,
                          color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'BERI AIR',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Status Air
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                'Status: $_statusAir',
                key: ValueKey(_statusAir),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _statusAir.contains('✓')
                      ? const Color(0xFF059669)
                      : kOnSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  //  RECENT ACTION
  // --------------------------------------------------------
  Widget _buildRecentAction() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: kSurfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF059669),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: kOnSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  const TextSpan(text: 'Pemberian terakhir: '),
                  TextSpan(
                    text: 'Pakan 200g',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kOnSurface,
                    ),
                  ),
                  const TextSpan(text: ' — 5 menit lalu'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  //  REUSABLE QUANTITY BUTTON
  // --------------------------------------------------------
  Widget _quantityButton({
    required IconData icon,
    required bool filled,
    required VoidCallback onTap,
    bool isBlue = false,
  }) {
    final Color activeColor =
        isBlue ? const Color(0xFF1976D2) : kPrimary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: filled ? activeColor : Colors.transparent,
          border: filled
              ? null
              : Border.all(color: kOutlineVariant, width: 1.5),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: activeColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: filled ? Colors.white : kOnSurface,
        ),
      ),
    );
  }
}