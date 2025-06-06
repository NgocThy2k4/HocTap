// models/MonAn.dart
class MonAn {
  String maMon;
  String maLoai;
  String tenMon;
  String? noiDungTomTat;
  String? noiDungChiTiet;
  double? donGia;
  double? donGiaKhuyenMai;
  String? khuyenMai;
  String? hinh;
  String? ngayCapNhat;
  String? dvt;
  int? trongNgay;

  MonAn({
    required this.maMon,
    required this.maLoai,
    required this.tenMon,
    this.noiDungTomTat,
    this.noiDungChiTiet,
    this.donGia,
    this.donGiaKhuyenMai,
    this.khuyenMai,
    this.hinh,
    this.ngayCapNhat,
    this.dvt,
    this.trongNgay,
  });

  // Chuyển đổi Map từ cơ sở dữ liệu thành đối tượng MonAn
  factory MonAn.fromMap(Map<String, dynamic> map) {
    return MonAn(
      maMon: map['ma_mon'],
      maLoai: map['ma_loai'],
      tenMon: map['ten_mon'],
      noiDungTomTat: map['noi_dung_tom_tat'],
      noiDungChiTiet: map['noi_dung_chi_tiet'],
      donGia: map['don_gia'] as double?,
      donGiaKhuyenMai: map['don_gia_khuyen_mai'] as double?,
      khuyenMai: map['khuyen_mai'],
      hinh: map['hinh'],
      ngayCapNhat: map['ngay_cap_nhat'],
      dvt: map['dvt'],
      trongNgay: map['trong_ngay'] as int?,
    );
  }

  // Chuyển đổi đối tượng MonAn thành Map để lưu vào cơ sở dữ liệu
  Map<String, dynamic> toMap() {
    return {
      'ma_mon': maMon,
      'ma_loai': maLoai,
      'ten_mon': tenMon,
      'noi_dung_tom_tat': noiDungTomTat,
      'noi_dung_chi_tiet': noiDungChiTiet,
      'don_gia': donGia,
      'don_gia_khuyen_mai': donGiaKhuyenMai,
      'khuyen_mai': khuyenMai,
      'hinh': hinh,
      'ngay_cap_nhat': ngayCapNhat,
      'dvt': dvt,
      'trong_ngay': trongNgay,
    };
  }
}
