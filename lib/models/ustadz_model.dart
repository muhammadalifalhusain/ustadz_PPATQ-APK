class Ustadz {
  final int idUser;
  final String namaUstadz;
  final String photo;
  final String accessToken;
  final int expiresIn;

  Ustadz({
    required this.idUser,
    required this.namaUstadz,
    required this.photo,
    required this.accessToken,
    required this.expiresIn,
  });

  factory Ustadz.fromJson(Map<String, dynamic> json) {
    return Ustadz(
      idUser: json['id'] ?? 0,
      namaUstadz: (json['nama'] ?? '').toString(),
      photo: (json['photo'] ?? '').toString(),
      accessToken: (json['accesToken'] ?? '').toString(), // 👈 sesuaikan dengan respons backend
      expiresIn: int.tryParse(json['expiresIn'].toString()) ?? 0,
    );
  }

}
