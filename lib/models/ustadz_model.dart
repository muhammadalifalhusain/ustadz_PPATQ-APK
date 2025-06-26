class Ustadz {
  final int idUser;
  final String namaUstadz;
  final String? photo;
  final String accessToken;
  final int expiresIn;

  Ustadz({
    required this.idUser,
    required this.namaUstadz,
    this.photo,
    required this.accessToken,
    required this.expiresIn,
  });

  factory Ustadz.fromJson(Map<String, dynamic> json) {
    return Ustadz(
      idUser: json['id'],
      namaUstadz: json['nama'],
      photo: json['photo'],
      accessToken: json['accesToken'],
      expiresIn: json['expiresIn'],
    );
  }
}
