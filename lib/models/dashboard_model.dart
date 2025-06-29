class Santri {
  final int noInduk;
  final String nama;
  final String kelas;
  final String? photo;

  Santri({
    required this.noInduk,
    required this.nama,
    required this.kelas,
    this.photo,
  });

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      noInduk: json['no_induk'] ?? 0,
      nama: json['nama'] ?? '-',
      kelas: json['kelas'] ?? '-',
      photo: json['photo'], 
    );
  }
}

class UstadSantriResponse {
  final int status;
  final String message;
  final String namaUstad;
  final String? photoUstad;
  final String kodeTahfidz;
  final String kelas;
  final List<Santri> listSantri;

  UstadSantriResponse({
    required this.status,
    required this.message,
    required this.namaUstad,
    this.photoUstad,
    required this.kodeTahfidz,
    required this.kelas,
    required this.listSantri,
  });

  factory UstadSantriResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return UstadSantriResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      namaUstad: data['namaUstad'] ?? '-',
      photoUstad: data['photo'], // bisa null
      kodeTahfidz: data['kodeTahfidz'] ?? '-',
      kelas: data['kelas'] ?? '-',
      listSantri: (data['listSantri'] as List?)
              ?.map((x) => Santri.fromJson(x))
              .toList() ??
          [],
    );
  }
}
