class TambahTahfidzModel {
  final String tanggal;
  final String idTahfidz;
  final String noInduk;
  final int kodeJuzSurah;
  final int hafalan;
  final int tilawah;
  final int kefasihan;
  final int dayaIngat;
  final int kelancaran;
  final int praktekTajwid;
  final int makhroj;
  final int tanafus;
  final int waqofWasol;
  final int ghorib;

  TambahTahfidzModel({
    required this.tanggal,
    required this.idTahfidz,
    required this.noInduk,
    required this.kodeJuzSurah,
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

  Map<String, dynamic> toJson() {
    return {
      "tanggal": tanggal,
      "idTahfidz": idTahfidz,
      "noInduk": noInduk,
      "kodeJuzSurah": kodeJuzSurah,
      "hafalan": hafalan,
      "tilawah": tilawah,
      "kefasihan": kefasihan,
      "dayaIngat": dayaIngat,
      "kelancaran": kelancaran,
      "praktekTajwid": praktekTajwid,
      "makhroj": makhroj,
      "tanafus": tanafus,
      "waqofWasol": waqofWasol,
      "ghorib": ghorib,
    };
  }
}
