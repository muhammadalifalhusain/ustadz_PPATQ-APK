class PenilaianTahfidzResponse {
  final int status;
  final String message;
  final PenilaianTahfidzData? data;

  PenilaianTahfidzResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PenilaianTahfidzResponse.fromJson(Map<String, dynamic> json) {
    return PenilaianTahfidzResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? PenilaianTahfidzData.fromJson(json['data'])
          : null,
    );
  }
}

class PenilaianTahfidzData {
  final int idTahfidz;
  final List<PenilaianItem> data;

  PenilaianTahfidzData({
    required this.idTahfidz,
    required this.data,
  });

  factory PenilaianTahfidzData.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List?;
    List<PenilaianItem> penilaianList = list != null
        ? list.map((e) => PenilaianItem.fromJson(e)).toList()
        : [];

    return PenilaianTahfidzData(
      idTahfidz: json['idTahfidz'] ?? 0,
      data: penilaianList,
    );
  }
}

class PenilaianItem {
  final int id;
  final int bulan;
  final String namaSantri;
  final String juz;
  final String hafalan;
  final String tilawah;
  final String kefasihan;
  final String dayaIngat;
  final String kelancaran;
  final String praktekTajwid;
  final String makhroj;
  final String tanafus;
  final String waqofWasol;
  final String ghorib;

  PenilaianItem({
    required this.id,
    required this.bulan,
    required this.namaSantri,
    required this.juz,
    required this.hafalan,
    required this.tilawah,
    required this.kefasihan,
    required this.dayaIngat,
    required this.kelancaran,
    required this.praktekTajwid,
    required this.makhroj,
    required this.tanafus,
    required this.waqofWasol,
    required this.ghorib,
  });

  factory PenilaianItem.fromJson(Map<String, dynamic> json) {
    return PenilaianItem(
      id: json['id'] ?? 0,
      bulan: json['bulan'] ?? 0,
      namaSantri: json['namaSantri'] ?? '',
      juz: json['juz'] ?? '',
      hafalan: json['hafalan'] ?? '',
      tilawah: json['tilawah'] ?? '',
      kefasihan: json['kefasihan'] ?? '',
      dayaIngat: json['dayaIngat'] ?? '',
      kelancaran: json['kelancaran'] ?? '',
      praktekTajwid: json['praktekTajwid'] ?? '',
      makhroj: json['makhroj'] ?? '',
      tanafus: json['tanafus'] ?? '',
      waqofWasol: json['waqofWasol'] ?? '',
      ghorib: json['ghorib'] ?? '',
    );
  }
}

class DetailTahfidz {
  final String namaSantri;
  final List<DetailTahfidzItem> data;

  DetailTahfidz({
    required this.namaSantri,
    required this.data,
  });

  factory DetailTahfidz.fromJson(Map<String, dynamic> json) {
    return DetailTahfidz(
      namaSantri: json['data']['namaSantri'] ?? '-',
      data: (json['data']['data'] as List)
          .map((item) => DetailTahfidzItem.fromJson(item))
          .toList(),
    );
  }
}



class DetailTahfidzItem{
  final int bulan;
  final int tahun;
  final String juz;
  final String hafalan;
  final String tilawah;
  final String kefasihan;
  final String dayaIngat;
  final String kelancaran;
  final String praktekTajwid;
  final String makhroj;
  final String tanafus;
  final String waqofWasol;
  final String ghorib;

  DetailTahfidzItem({
    required this.bulan,
    required this.tahun,
    required this.juz,
    required this.hafalan,
    required this.tilawah,
    required this.kefasihan,
    required this.dayaIngat,
    required this.kelancaran,
    required this.praktekTajwid,
    required this.makhroj,
    required this.tanafus,
    required this.waqofWasol,
    required this.ghorib,
  });

  factory DetailTahfidzItem.fromJson(Map<String, dynamic> json) {
    return DetailTahfidzItem(
      bulan: json['bulan'] ?? 0,
      tahun: json['tahun'] ?? 0,
      juz: json['juz'] ?? '-',
      hafalan: json['hafalan'] ?? '-',
      tilawah: json['tilawah'] ?? '-',
      kefasihan: json['kefasihan'] ?? '-',
      dayaIngat: json['dayaIngat'] ?? '-',
      kelancaran: json['kelancaran'] ?? '-',
      praktekTajwid: json['praktekTajwid'] ?? '-',
      makhroj: json['makhroj'] ?? '-',
      tanafus: json['tanafus'] ?? '-',
      waqofWasol: json['waqofWasol'] ?? '-',
      ghorib: json['ghorib'] ?? '-',
    );
  }
}
