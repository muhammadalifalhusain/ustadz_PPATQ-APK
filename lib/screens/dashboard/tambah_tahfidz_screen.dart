import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/dashboard_model.dart';
import '../../models/tambah_tahfidz_model.dart';
import '../../models/kode_juz_model.dart';
import '../../services/dashboard_service.dart';
import '../../services/tambah_tahfidz_service.dart';
import '../../services/kode_juz_service.dart';

class TambahTahfidzScreen extends StatefulWidget {
  final String idTahfidz;
  const TambahTahfidzScreen({Key? key, required this.idTahfidz}) : super(key: key);

  @override
  State<TambahTahfidzScreen> createState() => _TambahTahfidzScreenState();
}

class _TambahTahfidzScreenState extends State<TambahTahfidzScreen> {
  List<Santri> allSantri = [];
  List<Santri> filteredSantri = [];
  Santri? selectedSantri;
  String searchKeyword = '';
  DateTime selectedDate = DateTime.now();

  List<KodeJuz> allJuz = [];
  List<KodeJuz> filteredJuz = [];
  KodeJuz? selectedJuz;
  String searchJuz = '';
  final TextEditingController _santriController = TextEditingController();
  final TextEditingController _juzController = TextEditingController();

  final nilaiOptions = ['A', 'B', 'C', 'D', 'E'];
  final nilaiMap = {'A': 4, 'B': 3, 'C': 2, 'D': 1, 'E': 0};

  String nilaiHafalan = 'A';
  String nilaiTilawah = 'A';
  String nilaiKefasihan = 'A';
  String nilaiDayaIngat = 'A';
  String nilaiKelancaran = 'A';
  String nilaiTajwid = 'A';
  String nilaiMakhroj = 'A';
  String nilaiTanafus = 'A';
  String nilaiWaqof = 'A';
  String nilaiGhorib = 'A';

  @override
  void initState() {
    super.initState();
    fetchSantriList();
    fetchKodeJuz();
  }

  @override
  void dispose() {
    _santriController.dispose();
    _juzController.dispose();
    super.dispose();
  }

  void fetchSantriList() async {
    final response = await UstadSantriService.fetchSantriList();
    if (response != null) {
      setState(() {
        allSantri = response.listSantri;
      });
    }
  }

  void fetchKodeJuz() async {
    final response = await KodeJuzService.fetchKodeJuz();
    if (response != null) {
      setState(() {
        allJuz = response.data;
      });
    }
  }

  void filterSantri(String keyword) {
    setState(() {
      searchKeyword = keyword;
      if (keyword.isNotEmpty) {
        filteredSantri = allSantri
            .where((santri) => santri.nama.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      } else {
        filteredSantri = [];
      }
    });
  }

  void filterJuz(String keyword) {
    setState(() {
      searchJuz = keyword;
      if (keyword.isNotEmpty) {
        filteredJuz = allJuz
            .where((juz) => juz.nama.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      } else {
        filteredJuz = [];
      }
    });
  }

  Widget _buildDropdownNilai(String label, String currentValue, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2, 
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            )
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: currentValue,
                isExpanded: true,
                underline: const SizedBox(),
                items: nilaiOptions.map((val) => 
                  DropdownMenuItem(
                    value: val, 
                    child: Text(val, style: const TextStyle(fontWeight: FontWeight.w600))
                  )
                ).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (selectedSantri == null || selectedJuz == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Santri dan Juz harus dipilih'),
          backgroundColor: Colors.red,
        )
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final request = TambahTahfidzModel(
      tanggal: DateFormat('yyyy-MM-dd').format(selectedDate),
      idTahfidz: widget.idTahfidz,
      noInduk: selectedSantri!.noInduk.toString(),
      kodeJuzSurah: selectedJuz!.kode,
      hafalan: nilaiMap[nilaiHafalan]!,
      tilawah: nilaiMap[nilaiTilawah]!,
      kefasihan: nilaiMap[nilaiKefasihan]!,
      dayaIngat: nilaiMap[nilaiDayaIngat]!,
      kelancaran: nilaiMap[nilaiKelancaran]!,
      praktekTajwid: nilaiMap[nilaiTajwid]!,
      makhroj: nilaiMap[nilaiMakhroj]!,
      tanafus: nilaiMap[nilaiTanafus]!,
      waqofWasol: nilaiMap[nilaiWaqof]!,
      ghorib: nilaiMap[nilaiGhorib]!,
    );

    final success = await TambahTahfidzService.submitTahfidz(request);
    Navigator.of(context).pop();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil ditambahkan'),
          backgroundColor: Colors.green,
        )
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengirim data'),
          backgroundColor: Colors.red,
        )
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
          'Tambah Tahfidz',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pilih Santri",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _santriController,
                        decoration: InputDecoration(
                          labelText: 'Cari Nama Santri',
                          prefixIcon: const Icon(Icons.search, color: Colors.green),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.green, width: 2),
                          ),
                        ),
                        onChanged: filterSantri,
                      ),
                      
                      if (searchKeyword.isNotEmpty && filteredSantri.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            itemCount: filteredSantri.length,
                            itemBuilder: (context, index) {
                              final santri = filteredSantri[index];
                              return ListTile(
                                title: Text(santri.nama),
                                subtitle: Text("Kelas: ${santri.kelas}"),
                                onTap: () {
                                  setState(() {
                                    selectedSantri = santri;
                                    filteredSantri = [];
                                    searchKeyword = '';
                                    _santriController.text = santri.nama;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                      if (selectedSantri != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.person, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Santri: ${selectedSantri!.nama} (${selectedSantri!.kelas})",
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pilih Juz/Surah",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _juzController,
                        decoration: InputDecoration(
                          labelText: 'Cari Juz / Surah',
                          prefixIcon: const Icon(Icons.book, color: Colors.green),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.green, width: 2),
                          ),
                        ),
                        onChanged: filterJuz,
                      ),
                      if (searchJuz.isNotEmpty && filteredJuz.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            itemCount: filteredJuz.length,
                            itemBuilder: (context, index) {
                              final juz = filteredJuz[index];
                              return ListTile(
                                title: Text(juz.nama),
                                onTap: () {
                                  setState(() {
                                    selectedJuz = juz;
                                    filteredJuz = [];
                                    searchJuz = '';
                                    _juzController.text = juz.nama;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                      if (selectedJuz != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.book, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Juz/Surah: ${selectedJuz!.nama}",
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tanggal Penilaian",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() => selectedDate = pickedDate);
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            "Tanggal: ${DateFormat('dd MMM yyyy').format(selectedDate)}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green[700],
                            side: BorderSide(color: Colors.green.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Penilaian",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownNilai("Hafalan", nilaiHafalan, (v) => setState(() => nilaiHafalan = v!)),
                      _buildDropdownNilai("Tilawah", nilaiTilawah, (v) => setState(() => nilaiTilawah = v!)),
                      _buildDropdownNilai("Kefasihan", nilaiKefasihan, (v) => setState(() => nilaiKefasihan = v!)),
                      _buildDropdownNilai("Daya Ingat", nilaiDayaIngat, (v) => setState(() => nilaiDayaIngat = v!)),
                      _buildDropdownNilai("Kelancaran", nilaiKelancaran, (v) => setState(() => nilaiKelancaran = v!)),
                      _buildDropdownNilai("Tajwid", nilaiTajwid, (v) => setState(() => nilaiTajwid = v!)),
                      _buildDropdownNilai("Makhroj", nilaiMakhroj, (v) => setState(() => nilaiMakhroj = v!)),
                      _buildDropdownNilai("Tanafus", nilaiTanafus, (v) => setState(() => nilaiTanafus = v!)),
                      _buildDropdownNilai("Waqof/Wasol", nilaiWaqof, (v) => setState(() => nilaiWaqof = v!)),
                      _buildDropdownNilai("Ghorib", nilaiGhorib, (v) => setState(() => nilaiGhorib = v!)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.save, size: 20),
                  label: const Text(
                    "Simpan Penilaian",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}