import 'package:flutter/material.dart';

// ============================================================
//  COLOR CONSTANTS (matches HTML theme)
// ============================================================
const Color kPrimary = Color(0xFFAF101A);
const Color kOnPrimary = Color(0xFFFFFFFF);
const Color kBackground = Color(0xFFFCF9F8);
const Color kSurfaceContainerLowest = Color(0xFFFFFFFF);
const Color kSurfaceContainerLow = Color(0xFFF6F3F2);
const Color kSurfaceContainerHigh = Color(0xFFEAE7E7);
const Color kSurfaceContainerHighest = Color(0xFFE5E2E1);
const Color kOnSurface = Color(0xFF1B1C1C);
const Color kOnSurfaceVariant = Color(0xFF5B403D);
const Color kPrimaryFixed = Color(0xFFFFDAD6);

// ============================================================
//  TAMBAH JADWAL SCREEN
// ============================================================
class TambahJadwalScreen extends StatefulWidget {
  const TambahJadwalScreen({super.key});

  @override
  State<TambahJadwalScreen> createState() => _TambahJadwalScreenState();
}

class _TambahJadwalScreenState extends State<TambahJadwalScreen> {
  // --- State ---
  int _selectedHour = 6;
  int _selectedMinute = 30;

  // 0 = Pakan + Air, 1 = Pakan Saja, 2 = Air Saja
  int _selectedJenis = 0;

  double _porsiPakan = 200; // gram
  double _volumeAir = 500; // ml

  // S M T W T F S  (index 0..6)
  final List<bool> _hariAktif = [true, true, true, true, true, false, false];
  final List<String> _hariLabel = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  bool _ulangiSetiapMinggu = true;

  // FixedExtentScrollController untuk time picker
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    _hourController =
        FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController =
        FixedExtentScrollController(initialItem: _selectedMinute ~/ 5);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------
  //  BUILD
  // --------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWaktuPemberian(),
            const SizedBox(height: 20),
            _buildJenisPemberian(),
            const SizedBox(height: 20),
            _buildPorsiPakan(),
            const SizedBox(height: 20),
            _buildVolumeAir(),
            const SizedBox(height: 20),
            _buildHariAktif(),
            const SizedBox(height: 20),
            _buildUlangi(),
            const SizedBox(height: 32),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------
  //  APP BAR
  // --------------------------------------------------------
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFB71C1C),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Tambah Jadwal',
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _onSave,
          child: const Text(
            'Simpan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------
  //  SECTION 1 – WAKTU PEMBERIAN
  // --------------------------------------------------------
  Widget _buildWaktuPemberian() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Waktu Pemberian', showUnderline: true),
          const SizedBox(height: 20),
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: kSurfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // JAM
                SizedBox(
                  width: 80,
                  child: _buildTimeDrum(
                    controller: _hourController,
                    itemCount: 24,
                    label: (i) => i.toString().padLeft(2, '0'),
                    onChanged: (i) => setState(() => _selectedHour = i),
                  ),
                ),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: kPrimary,
                    fontFamily: 'Manrope',
                  ),
                ),
                // MENIT (kelipatan 5)
                SizedBox(
                  width: 80,
                  child: _buildTimeDrum(
                    controller: _minuteController,
                    itemCount: 12,
                    label: (i) => (i * 5).toString().padLeft(2, '0'),
                    onChanged: (i) =>
                        setState(() => _selectedMinute = i * 5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDrum({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int) label,
    required ValueChanged<int> onChanged,
  }) {
    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Colors.transparent,
          Colors.transparent,
          Colors.white,
        ],
        stops: const [0.0, 0.25, 0.75, 1.0],
      ).createShader(rect),
      blendMode: BlendMode.dstOut,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 52,
        perspective: 0.003,
        diameterRatio: 1.5,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final isSelected = controller.selectedItem == index;
            return Center(
              child: Text(
                label(index),
                style: TextStyle(
                  fontSize: isSelected ? 44 : 28,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Manrope',
                  color: isSelected
                      ? kPrimary
                      : kOnSurfaceVariant.withOpacity(0.35),
                ),
              ),
            );
          },
          childCount: itemCount,
        ),
      ),
    );
  }

  // --------------------------------------------------------
  //  SECTION 2 – JENIS PEMBERIAN
  // --------------------------------------------------------
  Widget _buildJenisPemberian() {
    final items = ['Pakan + Air', 'Pakan Saja', 'Air Saja'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelHeader('Jenis Pemberian'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: kSurfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: List.generate(
              items.length,
              (i) => Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedJenis = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedJenis == i
                          ? kPrimary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: _selectedJenis == i
                          ? [
                              BoxShadow(
                                color: kPrimary.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    child: Text(
                      items[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: _selectedJenis == i
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: _selectedJenis == i
                            ? kOnPrimary
                            : kOnSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------
  //  SECTION 3 – PORSI PAKAN
  // --------------------------------------------------------
  Widget _buildPorsiPakan() {
    final show = _selectedJenis == 0 || _selectedJenis == 1;
    if (!show) return const SizedBox.shrink();
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelHeader('Porsi Pakan (gram)',
              icon: Icons.restaurant_outlined),
          const SizedBox(height: 24),
          _buildSlider(
            value: _porsiPakan,
            min: 50,
            max: 500,
            minLabel: '50g',
            maxLabel: '500g',
            bubbleLabel: '${_porsiPakan.round()}g',
            onChanged: (v) => setState(() => _porsiPakan = v),
          ),
          const SizedBox(height: 16),
          _buildStepper(
            value: _porsiPakan,
            unit: 'g',
            step: 10,
            min: 50,
            max: 500,
            onChanged: (v) => setState(() => _porsiPakan = v),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  //  SECTION 4 – VOLUME AIR
  // --------------------------------------------------------
  Widget _buildVolumeAir() {
    final show = _selectedJenis == 0 || _selectedJenis == 2;
    if (!show) return const SizedBox.shrink();
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelHeader('Volume Air (ml)',
              icon: Icons.water_drop_outlined),
          const SizedBox(height: 24),
          _buildSlider(
            value: _volumeAir,
            min: 100,
            max: 1000,
            minLabel: '100ml',
            maxLabel: '1000ml',
            bubbleLabel: '${_volumeAir.round()}ml',
            onChanged: (v) => setState(() => _volumeAir = v),
          ),
          const SizedBox(height: 16),
          _buildStepper(
            value: _volumeAir,
            unit: 'ml',
            step: 50,
            min: 100,
            max: 1000,
            onChanged: (v) => setState(() => _volumeAir = v),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  //  REUSABLE SLIDER
  // --------------------------------------------------------
  Widget _buildSlider({
    required double value,
    required double min,
    required double max,
    required String minLabel,
    required String maxLabel,
    required String bubbleLabel,
    required ValueChanged<double> onChanged,
  }) {
    final pct = (value - min) / (max - min);
    return Column(
      children: [
        // Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: kPrimary,
            inactiveTrackColor: kSurfaceContainerHighest,
            thumbColor: kSurfaceContainerLowest,
            thumbShape:
                const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayColor: kPrimary.withOpacity(0.1),
            trackHeight: 6,
            valueIndicatorColor: kPrimary,
            valueIndicatorTextStyle:
                const TextStyle(color: kOnPrimary, fontWeight: FontWeight.w700),
            showValueIndicator: ShowValueIndicator.always,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            label: bubbleLabel,
            onChanged: onChanged,
          ),
        ),
        // Min / Max labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(minLabel,
                  style: const TextStyle(
                      fontSize: 11, color: kOnSurfaceVariant)),
              Text(maxLabel,
                  style: const TextStyle(
                      fontSize: 11, color: kOnSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------
  //  REUSABLE STEPPER
  // --------------------------------------------------------
  Widget _buildStepper({
    required double value,
    required String unit,
    required double step,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: kSurfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _stepperBtn(
            icon: Icons.remove,
            filled: false,
            onTap: () {
              if (value - step >= min) onChanged(value - step);
            },
          ),
          Text(
            '${value.round()}$unit',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              fontFamily: 'Manrope',
              color: kPrimary,
            ),
          ),
          _stepperBtn(
            icon: Icons.add,
            filled: true,
            onTap: () {
              if (value + step <= max) onChanged(value + step);
            },
          ),
        ],
      ),
    );
  }

  Widget _stepperBtn({
    required IconData icon,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? kPrimary : Colors.transparent,
          border: filled ? null : Border.all(color: kPrimary, width: 1.5),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: kPrimary.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Icon(icon,
            size: 18, color: filled ? kOnPrimary : kPrimary),
      ),
    );
  }

  // --------------------------------------------------------
  //  SECTION 5 – HARI AKTIF
  // --------------------------------------------------------
  Widget _buildHariAktif() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _labelHeader('Hari Aktif', icon: Icons.calendar_month_outlined),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final active = _hariAktif[i];
              return GestureDetector(
                onTap: () =>
                    setState(() => _hariAktif[i] = !_hariAktif[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? kPrimary : kSurfaceContainerHigh,
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: kPrimary.withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      _hariLabel[i],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: active ? kOnPrimary : kOnSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () =>
                    setState(() => _hariAktif.fillRange(0, 7, true)),
                child: const Text(
                  'Pilih Semua',
                  style: TextStyle(
                    color: kPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                    decorationColor: kPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    setState(() => _hariAktif.fillRange(0, 7, false)),
                child: const Text(
                  'Hapus Semua',
                  style: TextStyle(
                    color: kOnSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  //  SECTION 6 – ULANGI
  // --------------------------------------------------------
  Widget _buildUlangi() {
    return _card(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Ulangi Setiap Minggu',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: kOnSurface,
            ),
          ),
          Switch(
            value: _ulangiSetiapMinggu,
            onChanged: (v) => setState(() => _ulangiSetiapMinggu = v),
            activeColor: kPrimary,
            activeTrackColor: kPrimary.withOpacity(0.3),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: kSurfaceContainerHigh,
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------
  //  ACTIONS
  // --------------------------------------------------------
  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: kOnPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: kPrimary.withOpacity(0.3),
            ),
            child: const Text(
              'SIMPAN JADWAL',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: kPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Batalkan',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------
  //  SAVE HANDLER
  // --------------------------------------------------------
  void _onSave() {
    final aktif = <String>[];
    for (int i = 0; i < 7; i++) {
      if (_hariAktif[i]) aktif.add(_hariLabel[i]);
    }

    debugPrint('=== Simpan Jadwal ===');
    debugPrint(
        'Waktu : ${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')}');
    debugPrint('Jenis : ${['Pakan + Air', 'Pakan Saja', 'Air Saja'][_selectedJenis]}');
    if (_selectedJenis != 2)
      debugPrint('Pakan : ${_porsiPakan.round()}g');
    if (_selectedJenis != 1)
      debugPrint('Air   : ${_volumeAir.round()}ml');
    debugPrint('Hari  : ${aktif.join(', ')}');
    debugPrint('Ulangi: $_ulangiSetiapMinggu');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Jadwal ${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} berhasil disimpan!',
        ),
        backgroundColor: kPrimary,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.of(context).pop();
  }

  // --------------------------------------------------------
  //  HELPERS
  // --------------------------------------------------------
  Widget _card({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ??
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kSurfaceContainerLow),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAF101A).withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title, {bool showUnderline = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: kOnSurface,
          ),
        ),
        if (showUnderline) ...[
          const SizedBox(height: 4),
          Container(
            width: 60,
            height: 3,
            decoration: BoxDecoration(
              color: kPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ],
    );
  }

  Widget _labelHeader(String label, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: kOnSurfaceVariant),
          const SizedBox(width: 6),
        ],
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: kOnSurfaceVariant,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}