// models/LoaiMonAn.dart
class LoaiMonAn {
  String maLoai;
  String? tenLoai;
  String? moTa;
  String? hinh;

  LoaiMonAn({required this.maLoai, this.tenLoai, this.moTa, this.hinh});

  // Chuyển đổi Map từ cơ sở dữ liệu thành đối tượng LoaiMonAn
  factory LoaiMonAn.fromMap(Map<String, dynamic> map) {
    return LoaiMonAn(
      maLoai: map['ma_loai'],
      tenLoai: map['ten_loai'],
      moTa: map['mo_ta'],
      hinh: map['hinh'],
    );
  }

  // Chuyển đổi đối tượng LoaiMonAn thành Map để lưu vào cơ sở dữ liệu
  Map<String, dynamic> toMap() {
    return {
      'ma_loai': maLoai,
      'ten_loai': tenLoai,
      'mo_ta': moTa,
      'hinh': hinh,
    };
  }
}
