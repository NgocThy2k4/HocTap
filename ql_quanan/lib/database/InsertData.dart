import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:crypto/crypto.dart'; // Import thư viện crypto
import 'dart:convert'; // Import dart:convert cho utf8.encode



Future<void> insertInitialData(Database db) async {
  // Bảng vai_tro
  await db.insert('vai_tro', {'ma_vai_tro': 'QL', 'ten_vai_tro': 'quan_ly'});
  await db.insert('vai_tro', {'ma_vai_tro': 'NV', 'ten_vai_tro': 'nhan_vien'});
  await db.insert('vai_tro', {'ma_vai_tro': 'KH', 'ten_vai_tro': 'khach_hang'});

  // Bảng nguoi_dung
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'NV01', 'ten_dang_nhap': 'Ngọc Thy', 'mat_khau': 'Doan@123', 'email': 'ngocthy@gmail.com', 'ma_vai_tro': 'QL',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'NV02', 'ten_dang_nhap': 'Nguyên Khang', 'mat_khau': 'Doan@123', 'email': 'khang@gmail.com', 'ma_vai_tro': 'NV',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'NV03', 'ten_dang_nhap': 'Hải Đăng', 'mat_khau': 'Doan@123', 'email': 'dang@gmail.com', 'ma_vai_tro': 'NV',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'NV04', 'ten_dang_nhap': 'Trấn Thành', 'mat_khau': 'Doan@123', 'email': 'tranthanh@gmail.com', 'ma_vai_tro': 'QL',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'NV05', 'ten_dang_nhap': 'Nhiệt Ba', 'mat_khau': 'Doan@123', 'email': 'nhietba@gmail.com', 'ma_vai_tro': 'NV',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH01', 'ten_dang_nhap': 'Hải Yến', 'mat_khau': 'Doan@123', 'email': 'yennh@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH02', 'ten_dang_nhap': 'Lê Hà Ngọc Thy', 'mat_khau': 'Doan@123', 'email': 'lehangocthy@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH03', 'ten_dang_nhap': 'Lê Hà Quế Trâm', 'mat_khau': 'Doan@123', 'email': 'lehaquetram@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH04', 'ten_dang_nhap': 'Trần Thiên Tài', 'mat_khau': 'Doan@123', 'email': 'tranthientai@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH05', 'ten_dang_nhap': 'Trần Minh Tài', 'mat_khau': 'Doan@123', 'email': 'tranminhtai@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH06', 'ten_dang_nhap': 'Lê Xuân Tú', 'mat_khau': 'Doan@123', 'email': 'lexuantu@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH07', 'ten_dang_nhap': 'Lê Xuân Trinh', 'mat_khau': 'Doan@123', 'email': 'lexuantrinh@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH08', 'ten_dang_nhap': 'Thị Chon', 'mat_khau': 'Doan@123', 'email': 'lethichon@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH09', 'ten_dang_nhap': 'Tấn Triều', 'mat_khau': 'Doan@123', 'email': 'votantrieu@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH10', 'ten_dang_nhap': 'Võ Thanh Phong', 'mat_khau': 'Doan@123', 'email': 'vothanhphong@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH11', 'ten_dang_nhap': 'Kim Cúc', 'mat_khau': 'Doan@123', 'email': 'kimcuc@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH12', 'ten_dang_nhap': 'Hà Thị Mỹ', 'mat_khau': 'Doan@123', 'email': 'hathimy@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH13', 'ten_dang_nhap': 'Hà Lệ Băng Tiên', 'mat_khau': 'Doan@123', 'email': 'halebangtien@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH14', 'ten_dang_nhap': 'Hà Tuyết Diễm', 'mat_khau': 'Doan@123', 'email': 'hatuyetdiem@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH15', 'ten_dang_nhap': 'Võ Phạm Thảo Vy', 'mat_khau': 'Doan@123', 'email': 'vophamthaovy@gmail.com', 'ma_vai_tro': 'KH',});
  await db.insert('nguoi_dung', {'ma_nguoi_dung': 'KH16', 'ten_dang_nhap': 'Võ Phạm Tường Vy', 'mat_khau': 'Doan@123', 'email': 'vophamtuongvy@gmail.com', 'ma_vai_tro': 'KH',});

  // Bảng nhan_vien
  await db.insert('nhan_vien', {'ma_nhan_vien': 'NV01', 'ten_nhan_vien': 'Lê Hà Ngọc Thy', 'chuc_vu': 'Quản Lý',});
  await db.insert('nhan_vien', {'ma_nhan_vien': 'NV02', 'ten_nhan_vien': 'Lê Nguyên Khang', 'chuc_vu': 'Nhân Viên Phục Vụ',});
  await db.insert('nhan_vien', {'ma_nhan_vien': 'NV03', 'ten_nhan_vien': 'Phạm Hải Đăng', 'chuc_vu': 'Nhân Viên Bếp',});
  await db.insert('nhan_vien', {'ma_nhan_vien': 'NV04', 'ten_nhan_vien': 'Nguyễn Trấn Thành', 'chuc_vu': 'Nhân Viên Phục Vụ',});
  await db.insert('nhan_vien', {'ma_nhan_vien': 'NV05', 'ten_nhan_vien': 'Địch Lệ Nhiệt Ba', 'chuc_vu': 'Quản lý',});

  // Bảng khach_hang
  await db.insert('khach_hang', {'ma_khach_hang': 'KH01', 'ten_khach_hang': 'Nguyễn Hải Yến', 'dia_chi': '140 Lê Trọng Tấn', 'dien_thoai': '0812345678', 'hinh_anh': 'hinh1.jpg', 'ghi_chu': '',});
  await db.insert('khach_hang', {'ma_khach_hang': 'KH02', 'ten_khach_hang': 'Lê Hà Ngọc Thy', 'dia_chi': '743 Nguyễn Ảnh Thủ', 'dien_thoai': '0334909', 'hinh_anh': 'hinh2.jpg', 'ghi_chu': 'la sinh vien HUIT',});
  await db.insert('khach_hang', {'ma_khach_hang': 'KH03', 'ten_khach_hang': 'Le Ha Que tram', 'dia_chi': '534 Nguyễn Ảnh Thủ', 'dien_thoai': '081234566', 'hinh_anh': 'hinh3.jpg', 'ghi_chu': '',});
  await db.insert('khach_hang', {'ma_khach_hang': 'KH04', 'ten_khach_hang': 'Tran Thien Tai', 'dia_chi': '998 Lê Thị Riêng', 'dien_thoai': '0123459233', 'hinh_anh': 'hinh4.jpg', 'ghi_chu': 'la sinh vien Hutech',});
  await db.insert('khach_hang', {'ma_khach_hang': 'KH05', 'ten_khach_hang': 'Tran Minh Tai', 'dia_chi': '123 Hóc Môn', 'dien_thoai': '05532125', 'hinh_anh': 'hinh5.jpg', 'ghi_chu': 'Hoa khôi trường HUIT',});
  await db.insert('khach_hang', {'ma_khach_hang': 'KH06', 'ten_khach_hang': 'Lê Xuân Tú', 'dia_chi': '123 Lê Văn Khương', 'dien_thoai': '0123456789', 'hinh_anh': 'hinh6.jpg', 'ghi_chu': 'La hs truong THCS Nguyễn Trung Trực',});
  await db.insert('khach_hang', {'ma_khach_hang': 'KH07', 'ten_khach_hang': 'Lê Xuân Trinh', 'dia_chi': '744 Nguyễn Ảnh Thủ', 'dien_thoai': '0249123456', 'hinh_anh': 'hinh7.jpg', 'ghi_chu': 'Là Nam Vương Campuchia',});
  await db.insert('khach_hang', {'ma_khach_hang': 'KH08', 'ten_khach_hang': 'Lê Thị Chon', 'dia_chi': '1234/12 Củ Chi', 'dien_thoai': '015090508', 'hinh_anh': 'hinh8.jpg', 'ghi_chu': 'Là diễn viên siêu đỉnh',});
  await db.insert('khach_hang', {'ma_khach_hang': 'KH09', 'ten_khach_hang': 'Võ Tấn Triều', 'dia_chi': '3/5 Không Biết', 'dien_thoai': '0332253', 'hinh_anh': 'hinh9.jpg', 'ghi_chu': 'siêu cấp đỉnh cao thờ ơ',});
  await db.insert('khach_hang', {'ma_khach_hang': 'KH10', 'ten_khach_hang': 'Võ Thanh Phong', 'dia_chi': '123 Đồng Tháp 10', 'dien_thoai': '055777777', 'hinh_anh': 'hinh10.jpg', 'ghi_chu': 'thích gái dẹp',});
  await db.insert('khach_hang', {'ma_khach_hang': 'KH11', 'ten_khach_hang': 'Nguyễn Kim Cúc', 'dia_chi': '77/7 Đồng tháp', 'dien_thoai': '0775672', 'hinh_anh': 'hinh11.jpg', 'ghi_chu': 'thích phi công trẻ',});
  await db.insert('khach_hang', {'ma_khach_hang': 'KH12', 'ten_khach_hang': 'Hà Thị Mỹ', 'dia_chi': '15768 Lê Trọng tấn', 'dien_thoai': '09122135', 'hinh_anh': 'hinh12.jpg', 'ghi_chu': '',});
  await db.insert('khach_hang', {
    'ma_khach_hang': 'KH13',
    'ten_khach_hang': 'Hà Lệ Băng Tiên',
    'dia_chi': '743/1/1 Nguyễn Ảnh Thủ',
    'dien_thoai': '012339909',
    'hinh_anh': 'hinh13.jpg',
    'ghi_chu': '',
  });
  await db.insert('khach_hang', {
    'ma_khach_hang': 'KH14',
    'ten_khach_hang': 'Hà Tuyết Diễm',
    'dia_chi': '123/68 Lê Trọng Tấn',
    'dien_thoai': '0852570960',
    'hinh_anh': 'hinh14.jpg',
    'ghi_chu': 'da mặt rất đẹp',
  });
  await db.insert('khach_hang', {
    'ma_khach_hang': 'KH15',
    'ten_khach_hang': 'Võ Phạm Thảo Vy',
    'dia_chi': '568 Lê Trọng Tấn',
    'dien_thoai': '0123456789',
    'hinh_anh': 'hinh15.jpg',
    'ghi_chu': 'thích trai anime',
  });
  await db.insert('khach_hang', {
    'ma_khach_hang': 'KH16',
    'ten_khach_hang': 'Võ Phạm Tường Vy',
    'dia_chi': '123 Biên Giới QG',
    'dien_thoai': '012364123',
    'hinh_anh': 'hinh16.jpg',
    'ghi_chu': '',
  });

  // Bảng loai_mon_an
  await db.insert('loai_mon_an', {
    'ma_loai': 'LM01',
    'ten_loai': 'Món Canh',
    'mo_ta': 'Có nước chan',
    'hinh': 'Canh1.jpg',
  });
  await db.insert('loai_mon_an', {
    'ma_loai': 'LM02',
    'ten_loai': 'Món Cơm',
    'mo_ta': 'Gạo tẻ',
    'hinh': 'Com1.jpg',
  });
  await db.insert('loai_mon_an', {
    'ma_loai': 'LM03',
    'ten_loai': 'Món mặn',
    'mo_ta': 'Món mặn',
    'hinh': 'mon_man.jpg',
  });
  await db.insert('loai_mon_an', {
    'ma_loai': 'LM04',
    'ten_loai': 'Ăn Sáng',
    'mo_ta': 'Ăn Sáng',
    'hinh': 'An_sang.jpg',
  });
  await db.insert('loai_mon_an', {
    'ma_loai': 'LM05',
    'ten_loai': 'Món Súp',
    'mo_ta': 'Món Súp',
    'hinh': 'sup.jpg',
  });
  await db.insert('loai_mon_an', {
    'ma_loai': 'LM06',
    'ten_loai': 'Món gỏi',
    'mo_ta': 'Món gỏi',
    'hinh': 'Goi.jpg',
  });
  await db.insert('loai_mon_an', {
    'ma_loai': 'LM07',
    'ten_loai': 'Món Sào',
    'mo_ta': 'Món Sào',
    'hinh': 'MonSao.jpg',
  });
  await db.insert('loai_mon_an', {
    'ma_loai': 'LM08',
    'ten_loai': 'Tráng miệng',
    'mo_ta': 'Tráng miệng',
    'hinh': 'TrangMieng.jpg',
  });

  // Bảng mon_an
  await db.insert('mon_an', {
    'ma_mon': 'MA01',
    'ma_loai': 'LM02',
    'ten_mon': 'Cơm Tấm',
    'noi_dung_tom_tat': 'Cơn Tấm từ lâu đã là 1 nét đặc trưng của ẩm thực Việt',
    'noi_dung_chi_tiet': 'Cơm tấm',
    'don_gia': 25000,
    'don_gia_khuyen_mai': 23000,
    'khuyen_mai': 'Khăn lạnh ',
    'hinh': 'ComTam.jpg',
    'ngay_cap_nhat': '2018-04-17',
    'dvt': 'Đĩa',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA02',
    'ma_loai': 'LM02',
    'ten_mon': 'Cơm gà',
    'noi_dung_tom_tat':
        'Cơm gà là món ăn được chế biến với hình thức gà chiên nước mắm siêu ngon ',
    'noi_dung_chi_tiet': 'Cơm gà ',
    'don_gia': 35000,
    'don_gia_khuyen_mai': 30000,
    'khuyen_mai': 'Nước ngọt, Khăn lạnh ',
    'hinh': 'ComGa.jpg',
    'ngay_cap_nhat': '2018-03-13',
    'dvt': 'Đĩa',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA03',
    'ma_loai': 'LM02',
    'ten_mon': 'Cơm Sườn',
    'noi_dung_tom_tat': 'Cơm Sườn là món ăn đặc sản của miền Nam, Việt Nam',
    'noi_dung_chi_tiet': 'Cơm Sường Cọng / miếng',
    'don_gia': 38000,
    'don_gia_khuyen_mai': 35000,
    'khuyen_mai': 'Nước ngọt, Khăn lạnh ',
    'hinh': 'ComSuon.jpg',
    'ngay_cap_nhat': '2018-03-19',
    'dvt': 'Đĩa',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA04',
    'ma_loai': 'LM02',
    'ten_mon': 'Cơm Chay',
    'noi_dung_tom_tat':
        'Cơm chay là món ăn bỏ dưỡng làm từ cây trồng và không sử dụng các loại thịt. Ăn chay có thể giúp ta giảm cân. và giúp ta tu niệm =)))',
    'noi_dung_chi_tiet': 'Cơm chay',
    'don_gia': 15000,
    'don_gia_khuyen_mai': 12000,
    'khuyen_mai': 'Khăn lạnh ',
    'hinh': 'ComChay.jpg',
    'ngay_cap_nhat': '2018-04-17',
    'dvt': 'Đĩa',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA05',
    'ma_loai': 'LM01',
    'ten_mon': 'Canh Rau Ngọt',
    'noi_dung_tom_tat':
        'Canh rau Ngọt là món ăn làm từ rau ngọt, bổ dưỡng tốt cho sức khỏe. Nhưng không dành cho những ai không biết ăn rau. Nếu không biết ăn rau mà vẫn muốn ăn rau thì hãy sử dụng kẹo rau củ Kera của Hằng D',
    'noi_dung_chi_tiet': 'Rau ngót thịt bằm',
    'don_gia': 10000,
    'don_gia_khuyen_mai': 8000,
    'khuyen_mai': 'Khăn lạnh ',
    'hinh': 'RauNgot.jpg',
    'ngay_cap_nhat': '2018-03-13',
    'dvt': 'Chén',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA06',
    'ma_loai': 'LM01',
    'ten_mon': 'Rau Dền',
    'noi_dung_tom_tat':
        'Rau Dền là món ăn làm từ rau, bổ dưỡng tốt cho sức khỏe. Nhưng không dành cho những ai không biết ăn rau. Nếu không biết ăn rau mà vẫn muốn ăn rau thì hãy sử dụng kẹo rau củ Kera của Hằng Du Mục và Quang Linh',
    'noi_dung_chi_tiet': 'Rau dền, thịt bằm',
    'don_gia': 10000,
    'don_gia_khuyen_mai': 8000,
    'khuyen_mai': 'Nước ngọt',
    'hinh': 'RauDen.jpg',
    'ngay_cap_nhat': '2018-04-09',
    'dvt': 'Tô',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA07',
    'ma_loai': 'LM01',
    'ten_mon': 'Canh Khổ Qua',
    'noi_dung_tom_tat':
        'Canh Khổ Qua nhồi thịt. Cho những ai thích sự đắng cay',
    'noi_dung_chi_tiet': 'Canh Khổ Qua nhồi thịt.',
    'don_gia': 20000,
    'don_gia_khuyen_mai': 0,
    'khuyen_mai': 'Khăn lạnh ',
    'hinh': 'KhoQua.jpg',
    'ngay_cap_nhat': '2018-04-18',
    'dvt': 'Tô',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA08',
    'ma_loai': 'LM01',
    'ten_mon': 'Canh chua cá lóc',
    'noi_dung_tom_tat': 'Canh chua cá lóc',
    'noi_dung_chi_tiet': 'Canh chua cá lóc cho dân miền Tây',
    'don_gia': 25000,
    'don_gia_khuyen_mai': 0,
    'khuyen_mai': 'Khăn lạnh',
    'hinh': 'CanhChua.jpg',
    'ngay_cap_nhat': '2018-03-18',
    'dvt': 'tô',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA09',
    'ma_loai': 'LM01',
    'ten_mon': 'Canh Tần ô',
    'noi_dung_tom_tat': 'Canh tần Ô thịt bằm với hành lá',
    'noi_dung_chi_tiet': 'Canh tần Ô thịt bằm ',
    'don_gia': 15000,
    'don_gia_khuyen_mai': 0,
    'khuyen_mai': 'Khăn lạnh',
    'hinh': 'canhto.jpg',
    'ngay_cap_nhat': '2018-04-08',
    'dvt': 'tô',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA10',
    'ma_loai': 'LM03',
    'ten_mon': 'Cá lóc kho',
    'noi_dung_tom_tat': 'Cá lóc kho mắm + dĩa rau cà chua siêu ngon',
    'noi_dung_chi_tiet': 'Cá lóc kho mắm tôm',
    'don_gia': 30000,
    'don_gia_khuyen_mai': 27000,
    'khuyen_mai': 'Khăn lạnh',
    'hinh': 'CaKho.jpg',
    'ngay_cap_nhat': '2018-04-09',
    'dvt': 'Đĩa',
    'trong_ngay': 2,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA11',
    'ma_loai': 'LM03',
    'ten_mon': 'Thịt Kho Tiêu',
    'noi_dung_tom_tat': 'Thịt Kho Tiêu ăn ngon hơn khi có cà chua nha',
    'noi_dung_chi_tiet': 'Thịt Kho Tiêu với cơm trắng',
    'don_gia': 30000,
    'don_gia_khuyen_mai': 25000,
    'khuyen_mai': 'Khăn lạnh',
    'hinh': 'ThitKhoTieu.jpg',
    'ngay_cap_nhat': '2018-04-01',
    'dvt': 'đĩa',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA12',
    'ma_loai': 'LM03',
    'ten_mon': 'Thịt Rang Tôm',
    'noi_dung_tom_tat': 'Thịt Rang Tôm có dưa leo kèm theo',
    'noi_dung_chi_tiet': 'Thịt Rang Tôm cháy cạnh',
    'don_gia': 30000,
    'don_gia_khuyen_mai': 0,
    'khuyen_mai': 'Khăn lạnh',
    'hinh': 'ThitTom.jpg',
    'ngay_cap_nhat': '2018-04-24',
    'dvt': 'đĩa',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA13',
    'ma_loai': 'LM03',
    'ten_mon': 'Gà Kho Gừng',
    'noi_dung_tom_tat': 'Gà Kho Gừng + cà chua ăn kèm',
    'noi_dung_chi_tiet': 'Gà Kho Gừng với nấm kim châm',
    'don_gia': 35000,
    'don_gia_khuyen_mai': 32000,
    'khuyen_mai': 'Nước ngọt, Khăn lạnh',
    'hinh': 'GaGung.jpg',
    'ngay_cap_nhat': '2018-04-25',
    'dvt': 'Đĩa',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA14',
    'ma_loai': 'LM03',
    'ten_mon': 'Gà Kho Sả',
    'noi_dung_tom_tat': 'Gà Kho Sả',
    'noi_dung_chi_tiet': 'Gà Kho Sả ớt siêu cayyyy',
    'don_gia': 38000,
    'don_gia_khuyen_mai': 35000,
    'khuyen_mai': 'Nước ngọt, Khăn lạnh',
    'hinh': 'GaSa.jpg',
    'ngay_cap_nhat': '2018-04-26',
    'dvt': 'đĩa',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA15',
    'ma_loai': 'LM07',
    'ten_mon': 'Cải xào chua ngọt',
    'noi_dung_tom_tat': 'Cải xào chua ngọt',
    'noi_dung_chi_tiet': 'Cải xào chua ngọt với mắm nhĩ',
    'don_gia': 12000,
    'don_gia_khuyen_mai': 8000,
    'khuyen_mai': 'Nước ngọt',
    'hinh': 'hinh1.jpg',
    'ngay_cap_nhat': '2018-04-10',
    'dvt': 'tô',
    'trong_ngay': 2,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA16',
    'ma_loai': 'LM04',
    'ten_mon': 'Mì Trộn',
    'noi_dung_tom_tat': 'Mì Trộn',
    'noi_dung_chi_tiet': 'Mì Trộn thêm trứng',
    'don_gia': 25000,
    'don_gia_khuyen_mai': 23000,
    'khuyen_mai': 'Nước ngọt',
    'hinh': 'hinh2.jpg',
    'ngay_cap_nhat': '2018-04-07',
    'dvt': 'đĩa',
    'trong_ngay': 4,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA17',
    'ma_loai': 'LM04',
    'ten_mon': 'Mì Trộn',
    'noi_dung_tom_tat': 'Mì Trộn',
    'noi_dung_chi_tiet': 'Mì Trộn với xúc xích',
    'don_gia': 25000,
    'don_gia_khuyen_mai': 18000,
    'khuyen_mai': '0',
    'hinh': 'hinh3.jpg',
    'ngay_cap_nhat': '2018-03-12',
    'dvt': 'đĩa',
    'trong_ngay': 3,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA18',
    'ma_loai': 'LM04',
    'ten_mon': 'Mì Trộn',
    'noi_dung_tom_tat': 'Mì Trộn có cà chua và dưa leo kèm theo',
    'noi_dung_chi_tiet': 'Mì Trộn với Trứng, xúc xích',
    'don_gia': 30000,
    'don_gia_khuyen_mai': 0,
    'khuyen_mai': 'Nước ngọt',
    'hinh': 'hinh4.jpg',
    'ngay_cap_nhat': '2018-04-09',
    'dvt': 'đĩa',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA19',
    'ma_loai': 'LM05',
    'ten_mon': 'Súp mặn',
    'noi_dung_tom_tat': 'Súp mặn',
    'noi_dung_chi_tiet': 'Súp mặn',
    'don_gia': 12000,
    'don_gia_khuyen_mai': 10000,
    'khuyen_mai': 'Khăn lạnh',
    'hinh': 'hinh5.jpg',
    'ngay_cap_nhat': '2018-04-09',
    'dvt': 'ly',
    'trong_ngay': 2,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA20',
    'ma_loai': 'LM05',
    'ten_mon': 'Súp Cua',
    'noi_dung_tom_tat': 'Súp Cua',
    'noi_dung_chi_tiet': 'Súp Cua (có hành)',
    'don_gia': 15000,
    'don_gia_khuyen_mai': 12000,
    'khuyen_mai': 'Khăn lạnh',
    'hinh': 'hinh6.jpg',
    'ngay_cap_nhat': '2018-04-06',
    'dvt': 'ly',
    'trong_ngay': 5,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA21',
    'ma_loai': 'LM06',
    'ten_mon': 'Gỏi xoài',
    'noi_dung_tom_tat': 'Gỏi xoài',
    'noi_dung_chi_tiet': 'Gỏi xoài với mắm đường siêu siêu ngon',
    'don_gia': 20000,
    'don_gia_khuyen_mai': 0,
    'khuyen_mai': 'Khăn lạnh',
    'hinh': 'hinh7.jpg',
    'ngay_cap_nhat': '2018-03-12',
    'dvt': 'đĩa',
    'trong_ngay': 9,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA22',
    'ma_loai': 'LM06',
    'ten_mon': 'Gỏi Đu Đủ',
    'noi_dung_tom_tat': 'Gỏi Đu Đủ',
    'noi_dung_chi_tiet': 'Gỏi Đu Đủ',
    'don_gia': 18000,
    'don_gia_khuyen_mai': 0,
    'khuyen_mai': 'Khăn lạnh',
    'hinh': 'hinh8.jpg',
    'ngay_cap_nhat': '2025-03-20',
    'dvt': 'đĩa',
    'trong_ngay': 2,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA23',
    'ma_loai': 'LM06',
    'ten_mon': 'Gỏi Hũ Dừa',
    'noi_dung_tom_tat': 'Gỏi Hũ Dừa siêu ngon ',
    'noi_dung_chi_tiet': 'Gỏi Hũ Dừa bá cháy bò chét',
    'don_gia': 20000,
    'don_gia_khuyen_mai': 0,
    'khuyen_mai': '0',
    'hinh': 'hinh9.jpg',
    'ngay_cap_nhat': '2018-03-17',
    'dvt': 'đĩa',
    'trong_ngay': 2,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA24',
    'ma_loai': 'LM07',
    'ten_mon': 'Rau Muống Xào',
    'noi_dung_tom_tat': 'Rau Muống Xào dưa leo',
    'noi_dung_chi_tiet': 'Rau Muống Xào mắm chua ngọt',
    'don_gia': 8000,
    'don_gia_khuyen_mai': 5000,
    'khuyen_mai': '0',
    'hinh': 'hinh10.jpg',
    'ngay_cap_nhat': '2018-03-20',
    'dvt': 'đĩa',
    'trong_ngay': 2,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA25',
    'ma_loai': 'LM08',
    'ten_mon': 'Trái cây',
    'noi_dung_tom_tat': 'Trái cây',
    'noi_dung_chi_tiet': 'Đu đủ, dưa hấu, mãng cầu, xoài',
    'don_gia': 30000,
    'don_gia_khuyen_mai': 28000,
    'khuyen_mai': 'Khăn lạnh',
    'hinh': 'hinh11.jpg',
    'ngay_cap_nhat': '2018-03-19',
    'dvt': 'đĩa',
    'trong_ngay': 1,
  });
  await db.insert('mon_an', {
    'ma_mon': 'MA26',
    'ma_loai': 'LM08',
    'ten_mon': 'Rau câu',
    'noi_dung_tom_tat': 'Rau câu',
    'noi_dung_chi_tiet': 'Rau câu bảy màu',
    'don_gia': 25000,
    'don_gia_khuyen_mai': 0,
    'khuyen_mai': '0',
    'hinh': 'hinh12.jpg',
    'ngay_cap_nhat': '2018-03-13',
    'dvt': 'đĩa',
    'trong_ngay': 4,
  });
  // Bảng hoa_don
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD01',
    'ma_khach_hang': 'KH13',
    'ma_nhan_vien': 'NV01',
    'ngay_dat': '2018-04-08',
    'tong_tien': 200000,
    'tien_dat_coc': 50000,
    'con_lai': 150000,
    'hinh_thuc_thanh_toan': 'Tiền mặt',
    'ghi_chu': '',
  });
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD02',
    'ma_khach_hang': 'KH02',
    'ma_nhan_vien': 'NV02',
    'ngay_dat': '2018-04-09',
    'tong_tien': 53000,
    'tien_dat_coc': 3000,
    'con_lai': 50000,
    'hinh_thuc_thanh_toan': 'Tiền mặt',
    'ghi_chu': '',
  });
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD03',
    'ma_khach_hang': 'KH08',
    'ma_nhan_vien': 'NV02',
    'ngay_dat': '2018-03-06',
    'tong_tien': 9097700,
    'tien_dat_coc': 550900,
    'con_lai': 10000000,
    'hinh_thuc_thanh_toan': 'Tiền mặt',
    'ghi_chu': 'nợ cũ chưa trả',
  });
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD04',
    'ma_khach_hang': 'KH06',
    'ma_nhan_vien': 'NV03',
    'ngay_dat': '2018-03-11',
    'tong_tien': 23000,
    'tien_dat_coc': 0,
    'con_lai': 0,
    'hinh_thuc_thanh_toan': 'Thẻ',
    'ghi_chu': '',
  });
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD05',
    'ma_khach_hang': 'KH07',
    'ma_nhan_vien': 'NV02',
    'ngay_dat': '2018-03-20',
    'tong_tien': 779000,
    'tien_dat_coc': 0,
    'con_lai': 0,
    'hinh_thuc_thanh_toan': 'Tiền mặt',
    'ghi_chu': '',
  });
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD06',
    'ma_khach_hang': 'KH14',
    'ma_nhan_vien': 'NV01',
    'ngay_dat': '2018-03-05',
    'tong_tien': 23000,
    'tien_dat_coc': 0,
    'con_lai': 0,
    'hinh_thuc_thanh_toan': 'Chuyển khoản',
    'ghi_chu': '',
  });
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD07',
    'ma_khach_hang': 'KH12',
    'ma_nhan_vien': 'NV03',
    'ngay_dat': '2018-04-10',
    'tong_tien': 60000,
    'tien_dat_coc': 1200,
    'con_lai': 2000,
    'hinh_thuc_thanh_toan': 'Chuyển khoản',
    'ghi_chu': '',
  });
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD08',
    'ma_khach_hang': 'KH03',
    'ma_nhan_vien': 'NV04',
    'ngay_dat': '2018-04-10',
    'tong_tien': 520000,
    'tien_dat_coc': 2000,
    'con_lai': 12000,
    'hinh_thuc_thanh_toan': 'Tiền mặt',
    'ghi_chu': '',
  });
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD09',
    'ma_khach_hang': 'KH08',
    'ma_nhan_vien': 'NV04',
    'ngay_dat': '2018-03-11',
    'tong_tien': 5677000,
    'tien_dat_coc': 4777000,
    'con_lai': 1277000,
    'hinh_thuc_thanh_toan': 'Chuyển khoản',
    'ghi_chu': 'nợ quá nhiều',
  });
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD10',
    'ma_khach_hang': 'KH05',
    'ma_nhan_vien': 'NV05',
    'ngay_dat': '2018-03-19',
    'tong_tien': 534000,
    'tien_dat_coc': 42000,
    'con_lai': 24000,
    'hinh_thuc_thanh_toan': 'Chuyển khoản',
    'ghi_chu': '',
  });
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD11',
    'ma_khach_hang': 'KH01',
    'ma_nhan_vien': 'NV05',
    'ngay_dat': '2018-04-17',
    'tong_tien': 99600,
    'tien_dat_coc': 5000,
    'con_lai': 15300,
    'hinh_thuc_thanh_toan': 'Thẻ',
    'ghi_chu': '',
  });
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD12',
    'ma_khach_hang': 'KH08',
    'ma_nhan_vien': 'NV04',
    'ngay_dat': '2018-03-13',
    'tong_tien': 22000,
    'tien_dat_coc': 1000,
    'con_lai': 1200,
    'hinh_thuc_thanh_toan': 'Chuyển khoản',
    'ghi_chu': '',
  });
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD13',
    'ma_khach_hang': 'KH15',
    'ma_nhan_vien': 'NV02',
    'ngay_dat': '2018-04-09',
    'tong_tien': 12000,
    'tien_dat_coc': 1000,
    'con_lai': 0,
    'hinh_thuc_thanh_toan': 'Tiền mặt',
    'ghi_chu': '',
  });
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD14',
    'ma_khach_hang': 'KH03',
    'ma_nhan_vien': 'NV03',
    'ngay_dat': '2018-04-11',
    'tong_tien': 12000,
    'tien_dat_coc': 2000,
    'con_lai': 0,
    'hinh_thuc_thanh_toan': 'Chuyển khoản',
    'ghi_chu': '',
  });
  await db.insert('hoa_don', {
    'ma_hoa_don': 'HD15',
    'ma_khach_hang': 'KH09',
    'ma_nhan_vien': 'NV05',
    'ngay_dat': '2018-03-13',
    'tong_tien': 52777000,
    'tien_dat_coc': 527000,
    'con_lai': 2370000,
    'hinh_thuc_thanh_toan': 'Thẻ',
    'ghi_chu': 'thiếu nợ',
  });

  // Bảng chi_tiet_hoa_don
  await db.insert('chi_tiet_hoa_don', {
    'ma_hoa_don': 'HD01',
    'ma_mon': 'MA02',
    'so_luong': 5,
    'don_gia': 40000,
    'mon_thuc_don': 1,
  });
  await db.insert('chi_tiet_hoa_don', {
    'ma_hoa_don': 'HD01',
    'ma_mon': 'MA05',
    'so_luong': 3,
    'don_gia': 28000,
    'mon_thuc_don': 1,
  });
  await db.insert('chi_tiet_hoa_don', {
    'ma_hoa_don': 'HD01',
    'ma_mon': 'MA08',
    'so_luong': 9,
    'don_gia': 55000,
    'mon_thuc_don': 1,
  });
  await db.insert('chi_tiet_hoa_don', {
    'ma_hoa_don': 'HD02',
    'ma_mon': 'MA04',
    'so_luong': 5,
    'don_gia': 20000,
    'mon_thuc_don': 1,
  });
  await db.insert('chi_tiet_hoa_don', {
    'ma_hoa_don': 'HD06',
    'ma_mon': 'MA04',
    'so_luong': 2,
    'don_gia': 25000,
    'mon_thuc_don': 18,
  });
  await db.insert('chi_tiet_hoa_don', {
    'ma_hoa_don': 'HD07',
    'ma_mon': 'MA03',
    'so_luong': 5,
    'don_gia': 50000,
    'mon_thuc_don': 2,
  });
  await db.insert('chi_tiet_hoa_don', {
    'ma_hoa_don': 'HD09',
    'ma_mon': 'MA05',
    'so_luong': 5,
    'don_gia': 15000,
    'mon_thuc_don': 2,
  });
  await db.insert('chi_tiet_hoa_don', {
    'ma_hoa_don': 'HD13',
    'ma_mon': 'MA09',
    'so_luong': 9,
    'don_gia': 12000,
    'mon_thuc_don': 9,
  });
  await db.insert('chi_tiet_hoa_don', {
    'ma_hoa_don': 'HD14',
    'ma_mon': 'MA17',
    'so_luong': 5,
    'don_gia': 23000,
    'mon_thuc_don': 2,
  });
}
