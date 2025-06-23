import 'package:flutter/material.dart';
import '../../models/tahfidz_model.dart';

class DetailTahfidzScreen extends StatelessWidget {
  final DetailTahfidz detailTahfidz;

  const DetailTahfidzScreen({Key? key, required this.detailTahfidz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Detail Tahfidz',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Header Section with Gradient
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detailTahfidz.namaSantri,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${detailTahfidz.data.length} Penilaian Tersedia',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: detailTahfidz.data.length,
                itemBuilder: (context, index) {
                  final item = detailTahfidz.data[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Card with Month/Year
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2E7D32),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.book_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Juz ${item.juz}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${_getMonthName(item.bulan)} ${item.tahun}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _buildOverallGrade(item),
                            ],
                          ),
                        ),
                        // Grades Section
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Penilaian',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildGradeGrid([
                                GradeItem('Hafalan', item.hafalan),
                                GradeItem('Tilawah', item.tilawah),
                                GradeItem('Kefasihan', item.kefasihan),
                                GradeItem('Daya Ingat', item.dayaIngat),
                                GradeItem('Kelancaran', item.kelancaran),
                                GradeItem('Tajwid', item.praktekTajwid),
                                GradeItem('Makhroj', item.makhroj),
                                GradeItem('Tanafus', item.tanafus),
                                GradeItem('Waqof Wasol', item.waqofWasol),
                                GradeItem('Ghorib', item.ghorib),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeGrid(List<GradeItem> gradeItems) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: gradeItems.length,
      itemBuilder: (context, index) {
        final gradeItem = gradeItems[index];
        return _buildGradeCard(gradeItem.label, gradeItem.grade);
      },
    );
  }

  Widget _buildGradeCard(String label, String grade) {
    final gradeColor = _getGradeColor(grade);
    final gradeColorLight = _getGradeColorLight(grade);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: gradeColorLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: gradeColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: gradeColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                grade,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: gradeColor.withOpacity(0.8),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallGrade(dynamic item) {
    final grades = [
      item.hafalan,
      item.tilawah,
      item.kefasihan,
      item.dayaIngat,
      item.kelancaran,
      item.praktekTajwid,
      item.makhroj,
      item.tanafus,
      item.waqofWasol,
      item.ghorib,
    ];

    final averageGrade = _calculateAverageGrade(grades.cast<String>());

    final gradeColor = _getGradeColor(averageGrade);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: gradeColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                averageGrade,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'Rata-rata',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return const Color(0xFF4CAF50); // Green
      case 'B':
        return const Color(0xFF2196F3); // Blue
      case 'C':
        return const Color(0xFFFF9800); // Orange
      case 'D':
        return const Color(0xFFFF5722); // Deep Orange
      case 'E':
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  Color _getGradeColorLight(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return const Color(0xFFE8F5E8); // Light Green
      case 'B':
        return const Color(0xFFE3F2FD); // Light Blue
      case 'C':
        return const Color(0xFFFFF3E0); // Light Orange
      case 'D':
        return const Color(0xFFFBE9E7); // Light Deep Orange
      case 'E':
        return const Color(0xFFFFEBEE); // Light Red
      default:
        return const Color(0xFFF5F5F5); // Light Grey
    }
  }

  String _calculateAverageGrade(List<String> grades) {
    int totalScore = 0;
    for (String grade in grades) {
      switch (grade.toUpperCase()) {
        case 'A':
          totalScore += 4;
          break;
        case 'B':
          totalScore += 3;
          break;
        case 'C':
          totalScore += 2;
          break;
        case 'D':
          totalScore += 1;
          break;
        case 'E':
          totalScore += 0;
          break;
      }
    }
    
    double average = totalScore / grades.length;
    
    if (average >= 3.5) return 'A';
    if (average >= 2.5) return 'B';
    if (average >= 1.5) return 'C';
    if (average >= 0.5) return 'D';
    return 'E';
  }

  String _getMonthName(int month) {
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month];
  }
}

class GradeItem {
  final String label;
  final String grade;

  GradeItem(this.label, this.grade);
}