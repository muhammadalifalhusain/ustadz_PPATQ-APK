class Santri {
  final int noInduk;
  final String nama;
  final String kelas;

  Santri({
    required this.noInduk,
    required this.nama,
    required this.kelas,
  });

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      noInduk: json['no_induk'],
      nama: json['nama'],
      kelas: json['kelas'],
    );
  }
}

class UstadSantriResponse {
  final int status;
  final String message;
  final String namaUstad;
  final String kodeTahfidz;
  final String kelas;
  final List<Santri> listSantri;

  UstadSantriResponse({
    required this.status,
    required this.message,
    required this.namaUstad,
    required this.kodeTahfidz,
    required this.kelas,
    required this.listSantri,
  });

  factory UstadSantriResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return UstadSantriResponse(
      status: json['status'],
      message: json['message'],
      namaUstad: data['namaUstad'],
      kodeTahfidz: data['kodeTahfidz'],
      kelas: data['kelas'],
      listSantri: List<Santri>.from(
        data['listSantri'].map((x) => Santri.fromJson(x)),
      ),
    );
  }
}
