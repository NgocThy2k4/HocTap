// models/User.dart (CẬP NHẬT)
class User {
  final String maNguoiDung;
  final String tenDangNhap;
  final String email;
  final String maVaiTro; // 'QL', 'NV', 'KH'
  final String? maLienQuan; // ma_nhan_vien hoặc ma_khach_hang

  User({
    required this.maNguoiDung,
    required this.tenDangNhap,
    required this.email,
    required this.maVaiTro,
    this.maLienQuan,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      maNguoiDung: map['ma_nguoi_dung'] as String,
      tenDangNhap: map['ten_dang_nhap'] as String,
      email: map['email'] as String,
      maVaiTro: map['ma_vai_tro'] as String,
      maLienQuan: map['ma_lien_quan'] as String?, // Nếu bạn thêm cột này vào DB
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ma_nguoi_dung': maNguoiDung,
      'ten_dang_nhap': tenDangNhap,
      'email': email,
      'ma_vai_tro': maVaiTro,
      'ma_lien_quan': maLienQuan,
    };
  }
}
