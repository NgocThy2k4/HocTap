// models/User.dart
class User {
  final String maNguoiDung;
  final String tenDangNhap;
  final String matKhau; // Mật khẩu (đã hash)
  final String email;
  final String maVaiTro;
  final String? maLienQuan; // ma_khach_hang hoặc ma_nhan_vien

  User({
    required this.maNguoiDung,
    required this.tenDangNhap,
    required this.matKhau, // Vẫn là required khi tạo một User object
    required this.email,
    required this.maVaiTro,
    this.maLienQuan,
  });

  Map<String, dynamic> toMap() {
    return {
      'ma_nguoi_dung': maNguoiDung,
      'ten_dang_nhap': tenDangNhap,
      'mat_khau': matKhau, // Đảm bảo mật khẩu được đưa vào map khi cần
      'email': email,
      'ma_vai_tro': maVaiTro,
      'ma_lien_quan': maLienQuan,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      maNguoiDung: map['ma_nguoi_dung'] as String,
      tenDangNhap: map['ten_dang_nhap'] as String,
      matKhau: map['mat_khau'] as String, // Đảm bảo lấy mật khẩu từ DB
      email: map['email'] as String,
      maVaiTro: map['ma_vai_tro'] as String,
      maLienQuan: map['ma_lien_quan'] as String?,
    );
  }

  // Phương thức copyWith để tạo bản sao với các trường được thay đổi
  User copyWith({
    String? maNguoiDung,
    String? tenDangNhap,
    String? matKhau,
    String? email,
    String? maVaiTro,
    String? maLienQuan,
  }) {
    return User(
      maNguoiDung: maNguoiDung ?? this.maNguoiDung,
      tenDangNhap: tenDangNhap ?? this.tenDangNhap,
      matKhau: matKhau ?? this.matKhau, // Giữ nguyên mật khẩu nếu không truyền
      email: email ?? this.email,
      maVaiTro: maVaiTro ?? this.maVaiTro,
      maLienQuan: maLienQuan ?? this.maLienQuan,
    );
  }
}
