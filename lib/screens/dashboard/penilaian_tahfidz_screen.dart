import 'package:flutter/material.dart';
import '../../models/penilaian_tahfidz_model.dart';
import '../../services/penilaian_tahfidz_service.dart';

class PenilaianTahfidzScreen extends StatefulWidget {
  const PenilaianTahfidzScreen({Key? key}) : super(key: key);

  @override
  State<PenilaianTahfidzScreen> createState() => _PenilaianTahfidzScreenState();
}

class _PenilaianTahfidzScreenState extends State<PenilaianTahfidzScreen> {
  late Future<PenilaianTahfidzResponse?> _penilaianFuture;

  @override
  void initState() {
    super.initState();
    _penilaianFuture = PenilaianTahfidzService().fetchPenilaianTahfidz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penilaian Tahfidz'),
        backgroundColor: Colors.green[700],
      ),
      body: FutureBuilder<PenilaianTahfidzResponse?>(
        future: _penilaianFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Gagal memuat data"));
          }

          final dataList = snapshot.data!.data?.data ?? [];

          if (dataList.isEmpty) {
            return const Center(child: Text("Belum ada data penilaian"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final item = dataList[index];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(item.namaSantri, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Juz: ${item.juz}"),
                      Text("Hafalan: ${item.hafalan}"),
                      Text("Tilawah: ${item.tilawah}"),
                      Text("Kefasihan: ${item.kefasihan}"),
                      Text("Daya Ingat: ${item.dayaIngat}"),
                      Text("Kelancaran: ${item.kelancaran}"),
                      Text("Tajwid: ${item.praktekTajwid}"),
                      Text("Makhroj: ${item.makhroj}"),
                      Text("Tanafus: ${item.tanafus}"),
                      Text("Waqof Wasol: ${item.waqofWasol}"),
                      Text("Ghorib: ${item.ghorib}"),
                    ],
                  ),
                  isThreeLine: true,
                  contentPadding: const EdgeInsets.all(12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
