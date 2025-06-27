import 'package:flutter/material.dart';
import 'detail_tahfidz_screen.dart';

import '../login_screen.dart';

import '../../models/dashboard_model.dart';

import '../../utils/session_manager.dart';
import '../../services/dashboard_service.dart';
import '../../services/tahfidz_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  UstadSantriResponse? ustadSantriData;
  bool isLoading = true;
  String errorMessage = '';
  bool isNotUstadzRole = false;


  @override
  void initState() {
    super.initState();
    _loadSantriData();
  }

  Future<void> _loadSantriData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      isNotUstadzRole = false; 
    });

    try {
      final data = await UstadSantriService.fetchSantriList();
      if (data == null) {
        setState(() {
          isLoading = false;
          isNotUstadzRole = true; // ini penting agar masuk ke view khusus role salah
        });
      } else {
        setState(() {
          ustadSantriData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }


  void getDetail(int noInduk) async {
    final detail = await TahfidzService.getDetailTahfidz(noInduk);
    if (detail != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailTahfidzScreen(detailTahfidz: detail), 
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat detail tahfidz")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2E7D32),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
            ),
            SizedBox(height: 16),
            Text(
              'Memuat data santri...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadSantriData,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // ✅ Jika tidak ada data santri (bukan role ustadz)
    if (isNotUstadzRole) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.block,
                size: 80,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              const Text(
                'Maaf, anda tercatat bukan pengajar(tahfidz)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              _buildLogoutButton(context),
            ],
          ),
        ),
      );
    }


    // ✅ Data tersedia
    return RefreshIndicator(
      onRefresh: _loadSantriData,
      color: const Color(0xFF2E7D32),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUstadInfoCard(),
            const SizedBox(height: 10),
            _buildLogoutButton(context),
            const SizedBox(height: 10),
            _buildSantriListHeader(),
            const SizedBox(height: 12),
            _buildSantriList(),
          ],
        ),
      ),
    );
  }


  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 216, 47, 72),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 192, 33, 22).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          leading: const Icon(Icons.logout, color: Colors.white),
          title: const Text(
            'Keluar Akun',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () async {
            await SessionManager.clearSession();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
              (route) => false,
            );
          },
        ),
      ),
    );
  }

  Widget _buildUstadInfoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Side accent
            Container(
              width: 6,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                ),
                borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xFF2E7D32),
                      child: Text(
                        ustadSantriData!.namaUstad
                            .split(' ')
                            .map((e) => e[0])
                            .take(2)
                            .join(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ustadSantriData!.namaUstad,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          Text(
                            'Ustad Pengampu',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.school,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Kelas ${ustadSantriData!.kodeTahfidz.toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSantriListHeader() {
    final totalSantri = ustadSantriData!.listSantri.length;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Daftar Santri',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$totalSantri Santri',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSantriList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ustadSantriData!.listSantri.length,
      itemBuilder: (context, index) {
        final santri = ustadSantriData!.listSantri[index];
        return _buildSantriCard(santri, index);
      },
    );
  }

  Widget _buildSantriCard(Santri santri, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            _showSantriDetail(santri);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.primaries[index % Colors.primaries.length],
                        Colors.primaries[index % Colors.primaries.length].shade300,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      santri.nama.split(' ').map((e) => e[0]).take(2).join(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        santri.nama,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E2E2E),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.menu_book, color: Colors.green),
                  tooltip: 'Lihat Tahfidz',
                  onPressed: () {
                    getDetail(santri.noInduk);
                  },
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSantriDetail(Santri santri) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Detail Santri',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Nomor Induk', santri.noInduk.toString()),
            _buildDetailRow('Kelas', santri.kelas.toUpperCase()),
            _buildDetailRow('Kelas Tahfidz', ustadSantriData!.kelas),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}