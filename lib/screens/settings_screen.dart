import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Color Palette dari Tailwind Config
  static const Color primary = Color(0xFFAF101A);
  static const Color primaryContainer = Color(0xFFD32F2F);
  static const Color primaryFixed = Color(0xFFFFDAD6);
  static const Color surfaceContainerLowest = Colors.white;
  static const Color surfaceContainerLow = Color(0xFFF6F3F2);
  static const Color surfaceContainer = Color(0xFFF0EDED);
  static const Color surfaceContainerHigh = Color(0xFFEAE7E7); // <-- Variabel yang ditambahkan
  static const Color onSurface = Color(0xFF1B1C1C);
  static const Color onSurfaceVariant = Color(0xFF5B403D);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);

  // State untuk Notifikasi (Toggle Switch)
  bool _notifPakanHabis = true;
  bool _notifSuhu = true;
  bool _notifJadwal = false;
  bool _notifOffline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8), // background
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol back
        backgroundColor: const Color(0xFFB71C1C),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Pengaturan',
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32).copyWith(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 48),
            _buildPerangkatSection(),
            const SizedBox(height: 32),
            _buildNotifikasiSection(),
            const SizedBox(height: 32),
            _buildAmbangBatasSection(),
            const SizedBox(height: 32),
            _buildAkunSection(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // PROFILE SECTION
  // ─────────────────────────────────────────────
  Widget _buildProfileSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryFixed.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'PN',
                style: GoogleFonts.manrope(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pak Nurhadi',
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'nurhadi@farm.com',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: primary,
              side: const BorderSide(color: primary, width: 2),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: Text(
              'Edit Profil',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // PERANGKAT SECTION
  // ─────────────────────────────────────────────
  Widget _buildPerangkatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.router_rounded, 'Perangkat IoT'),
        _buildCardContainer(
          children: [
            _buildListTile(
              title: 'Status Koneksi',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'ESP32',
                    style: GoogleFonts.inter(fontSize: 13, color: onSurfaceVariant),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7), // green-100
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E), // green-500
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Terhubung',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF166534), // green-800
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildListTile(
              title: 'ID Perangkat',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: surfaceContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'ESP32-SIPPA-001',
                      style: GoogleFonts.robotoMono(
                        fontSize: 12,
                        color: onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.content_copy_rounded, size: 20, color: onSurfaceVariant),
                ],
              ),
            ),
            _buildListTile(
              title: 'Interval Pembaruan Data',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '5 detik',
                    style: GoogleFonts.inter(fontSize: 14, color: onSurfaceVariant),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded, size: 24, color: onSurfaceVariant),
                ],
              ),
            ),
            _buildListTile(
              title: 'Tambah Perangkat',
              titleColor: primary,
              trailing: const Icon(Icons.chevron_right_rounded, size: 24, color: primary),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // NOTIFIKASI SECTION
  // ─────────────────────────────────────────────
  Widget _buildNotifikasiSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.notifications_rounded, 'Notifikasi'),
        _buildCardContainer(
          children: [
            _buildSwitchTile(
              title: 'Notifikasi Pakan Habis',
              value: _notifPakanHabis,
              onChanged: (val) => setState(() => _notifPakanHabis = val),
            ),
            _buildSwitchTile(
              title: 'Peringatan Suhu',
              value: _notifSuhu,
              onChanged: (val) => setState(() => _notifSuhu = val),
            ),
            _buildSwitchTile(
              title: 'Konfirmasi Jadwal',
              value: _notifJadwal,
              onChanged: (val) => setState(() => _notifJadwal = val),
            ),
            _buildSwitchTile(
              title: 'Perangkat Offline',
              value: _notifOffline,
              onChanged: (val) => setState(() => _notifOffline = val),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // AMBANG BATAS SECTION
  // ─────────────────────────────────────────────
  Widget _buildAmbangBatasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.speed_rounded, 'Batas Peringatan'),
        _buildCardContainer(
          children: [
            _buildListTile(
              title: 'Batas Stok Pakan Minimum',
              trailing: _buildHighlightBadge('20%'),
            ),
            _buildListTile(
              title: 'Batas Suhu Maksimum',
              trailing: _buildHighlightBadge('32°C'),
            ),
            _buildListTile(
              title: 'Batas Kelembapan',
              trailing: _buildHighlightBadge('80%'),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // AKUN SECTION
  // ─────────────────────────────────────────────
  Widget _buildAkunSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.person_rounded, 'Akun'),
        _buildCardContainer(
          children: [
            _buildListTile(
              title: 'Keamanan',
              trailing: const Icon(Icons.chevron_right_rounded, size: 24, color: onSurfaceVariant),
            ),
            _buildListTile(
              title: 'Bantuan & FAQ',
              trailing: const Icon(Icons.chevron_right_rounded, size: 24, color: onSurfaceVariant),
            ),
            _buildListTile(
              title: 'Tentang SIPPA',
              trailing: Text(
                'Versi 1.0.0',
                style: GoogleFonts.inter(fontSize: 14, color: onSurfaceVariant),
              ),
            ),
            // Tombol Keluar
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Keluar',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: error,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // HELPERS COMPONENT
  // ─────────────────────────────────────────────
  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required Widget trailing,
    Color titleColor = onSurface,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: titleColor,
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: onSurface,
              ),
            ),
            CupertinoSwitch(
              value: value,
              onChanged: onChanged,
              activeColor: primary,
              trackColor: surfaceContainerHigh, // Error sebelumnya berasal dari sini
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
      ),
    );
  }
}