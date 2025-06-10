// models/User.dart
class User {
  String maNguoiDung;
  String tenDangNhap;
  String matKhau;
  String email;
  String maVaiTro;
  String? maLienQuan; // Có thể null nếu không liên quan đến KH/NV
  String? hinhAnh; // THÊM DÒNG NÀY

  User({
    required this.maNguoiDung,
    required this.tenDangNhap,
    required this.matKhau,
    required this.email,
    required this.maVaiTro,
    this.maLienQuan,
    this.hinhAnh, // THÊM VÀO CONSTRUCTOR
  });

  // Factory constructor để tạo User từ Map (từ database)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      maNguoiDung: map['ma_nguoi_dung'],
      tenDangNhap: map['ten_dang_nhap'],
      matKhau: map['mat_khau'],
      email: map['email'],
      maVaiTro: map['ma_vai_tro'],
      maLienQuan: map['ma_lien_quan'],
      hinhAnh: map['hinh_anh'], // ĐỌC CỘT HÌNH ẢNH NẾU CÓ
    );
  }

  // To Map method (nếu cần để lưu vào DB)
  Map<String, dynamic> toMap() {
    return {
      'ma_nguoi_dung': maNguoiDung,
      'ten_dang_nhap': tenDangNhap,
      'mat_khau': matKhau,
      'email': email,
      'ma_vai_tro': maVaiTro,
      'ma_lien_quan': maLienQuan,
      'hinh_anh': hinhAnh, // LƯU CỘT HÌNH ẢNH
    };
  }
}
