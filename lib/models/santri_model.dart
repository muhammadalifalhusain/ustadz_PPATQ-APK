class SantriModel {
  final int status;
  final String message;
  final SantriTahfidzData data;

  SantriModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SantriModel.fromJson(Map<String, dynamic> json) {
    return SantriModel(
      status: json['status'],
      message: json['message'],
      data: SantriTahfidzData.fromJson(json['data']),
    );
  }
}

class SantriTahfidzData {
  final String namaUstad;
  final String kodeTahfidz;
  final String kelas;
  final List<SantriItem> listSantri;

  SantriTahfidzData({
    required this.namaUstad,
    required this.kodeTahfidz,
    required this.kelas,
    required this.listSantri,
  });

  factory SantriTahfidzData.fromJson(Map<String, dynamic> json) {
    var list = json['listSantri'] as List;
    List<SantriItem> santriList =
        list.map((e) => SantriItem.fromJson(e)).toList();

    return SantriTahfidzData(
      namaUstad: json['namaUstad'],
      kodeTahfidz: json['kodeTahfidz'],
      kelas: json['kelas'],
      listSantri: santriList,
    );
  }
}

class SantriItem {
  final int noInduk;
  final String nama;
  final String kelas;

  SantriItem({
    required this.noInduk,
    required this.nama,
    required this.kelas,
  });

  factory SantriItem.fromJson(Map<String, dynamic> json) {
    return SantriItem(
      noInduk: json['no_induk'],
      nama: json['nama'],
      kelas: json['kelas'],
    );
  }
}
