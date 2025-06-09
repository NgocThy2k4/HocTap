// models/NhanVien.dart
class NhanVien {
  final String maNhanVien;
  final String tenNhanVien;
  final String? chucVu;
  final String? diaChi;
  final String? dienThoai;
  final String? hinhAnh;
  final String? ghiChu;

  NhanVien({
    required this.maNhanVien,
    required this.tenNhanVien,
    this.chucVu,
    this.diaChi,
    this.dienThoai,
    this.hinhAnh,
    this.ghiChu,
  });

  Map<String, dynamic> toMap() {
    return {
      'ma_nhan_vien': maNhanVien,
      'ten_nhan_vien': tenNhanVien,
      'chuc_vu': chucVu,
      'dia_chi': diaChi,
      'dien_thoai': dienThoai,
      'hinh_anh': hinhAnh,
      'ghi_chu': ghiChu,
    };
  }

  factory NhanVien.fromMap(Map<String, dynamic> map) {
    return NhanVien(
      maNhanVien: map['ma_nhan_vien'] as String,
      tenNhanVien: map['ten_nhan_vien'] as String,
      chucVu: map['chuc_vu'] as String?,
      diaChi: map['dia_chi'] as String?,
      dienThoai: map['dien_thoai'] as String?,
      hinhAnh: map['hinh_anh'] as String?,
      ghiChu: map['ghi_chu'] as String?,
    );
  }
}
