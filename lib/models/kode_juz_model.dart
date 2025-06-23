class KodeJuz {
  final int id;
  final String nama;

  KodeJuz({required this.id, required this.nama});

  factory KodeJuz.fromJson(Map<String, dynamic> json) {
    return KodeJuz(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
    );
  }
}

class KodeJuzResponse {
  final int status;
  final String message;
  final List<KodeJuz> data;

  KodeJuzResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KodeJuzResponse.fromJson(Map<String, dynamic> json) {
    return KodeJuzResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((item) => KodeJuz.fromJson(item))
          .toList(),
    );
  }
}
