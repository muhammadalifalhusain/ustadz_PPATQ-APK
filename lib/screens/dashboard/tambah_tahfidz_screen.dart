import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/dashboard_model.dart';
import '../../models/tambah_tahfidz_model.dart';
import '../../services/dashboard_service.dart';
import '../../services/tambah_tahfidz_service.dart';

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
  int kodeJuzSurah = 1;

  final _formKey = GlobalKey<FormState>();
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
  }

  void fetchSantriList() async {
    final response = await UstadSantriService.fetchSantriList();
    if (response != null) {
      setState(() {
        allSantri = response.listSantri;
        filteredSantri = allSantri;
      });
    }
  }

  void filterSantri(String keyword) {
    setState(() {
      searchKeyword = keyword;
      filteredSantri = allSantri
          .where((santri) => santri.nama.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  Widget _buildDropdownNilai(String label, String currentValue, Function(String?) onChanged) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text(label)),
        Expanded(
          flex: 3,
          child: DropdownButton<String>(
            value: currentValue,
            isExpanded: true,
            items: nilaiOptions.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (selectedSantri == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih santri terlebih dahulu')));
      return;
    }

    final request = TambahTahfidzModel(
      tanggal: DateFormat('yyyy-MM-dd').format(selectedDate),
      idTahfidz: widget.idTahfidz,
      noInduk: selectedSantri!.noInduk.toString(),
      kodeJuzSurah: kodeJuzSurah,
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

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berhasil ditambahkan')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengirim data')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Penilaian Tahfidz")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Pencarian Santri
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Cari Nama Santri',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: filterSantri,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
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
                          searchKeyword = santri.nama;
                        });
                      },
                    );
                  },
                ),
              ),
              if (selectedSantri != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.green),
                      const SizedBox(width: 8),
                      Text("Santri: ${selectedSantri!.nama} (${selectedSantri!.kelas})"),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kode Juz / Surah',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) => kodeJuzSurah = int.tryParse(val) ?? 1,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text("Tanggal: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
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
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.save),
                label: const Text("Simpan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
