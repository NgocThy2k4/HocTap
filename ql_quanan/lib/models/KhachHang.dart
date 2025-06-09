// models/KhachHang.dart
class KhachHang {
  final String maKhachHang;
  final String tenKhachHang;
  final String? diaChi;
  final String? dienThoai;
  final String? hinhAnh;
  final String? ghiChu;

  KhachHang({
    required this.maKhachHang,
    required this.tenKhachHang,
    this.diaChi,
    this.dienThoai,
    this.hinhAnh,
    this.ghiChu,
  });

  Map<String, dynamic> toMap() {
    return {
      'ma_khach_hang': maKhachHang,
      'ten_khach_hang': tenKhachHang,
      'dia_chi': diaChi,
      'dien_thoai': dienThoai,
      'hinh_anh': hinhAnh,
      'ghi_chu': ghiChu,
    };
  }

  factory KhachHang.fromMap(Map<String, dynamic> map) {
    return KhachHang(
      maKhachHang: map['ma_khach_hang'] as String,
      tenKhachHang: map['ten_khach_hang'] as String,
      diaChi: map['dia_chi'] as String?,
      dienThoai: map['dien_thoai'] as String?,
      hinhAnh: map['hinh_anh'] as String?,
      ghiChu: map['ghi_chu'] as String?,
    );
  }
}
