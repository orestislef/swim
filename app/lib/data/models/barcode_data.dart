class BarcodeData {
  final String code;
  final String svg;

  const BarcodeData({required this.code, required this.svg});

  factory BarcodeData.fromJson(Map<String, dynamic> json) {
    return BarcodeData(
      code: json['code'] as String? ?? '',
      svg: json['svg'] as String? ?? '',
    );
  }
}
