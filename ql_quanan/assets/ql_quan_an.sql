CREATE DATABASE ql_quan_an
GO
USE ql_quan_an
GO

--CREATE TABLE tai_khoan (
--    ma_tai_khoan nvarchar(15) NOT NULL PRIMARY KEY,
--    ma_nhan_vien nvarchar(15) NOT NULL,
--    ten_dang_nhap nvarchar(100),
--    mat_khau nvarchar(100),
--    FOREIGN KEY (ma_nhan_vien) REFERENCES nhan_vien (ma_nhan_vien)
--);
CREATE TABLE vai_tro (
    ma_vai_tro NVARCHAR(15) PRIMARY KEY,
    ten_vai_tro NVARCHAR(100) NOT NULL,
);

CREATE TABLE nguoi_dung (
    ma_nguoi_dung nvarchar(15) NOT NULL PRIMARY KEY,
    ten_dang_nhap nVARCHAR(50) NOT NULL,
    mat_khau nVARCHAR(255) NOT NULL,
    email nVARCHAR(100) UNIQUE NOT NULL,
    ma_vai_tro NVARCHAR(15) NOT NULL,
    -- thoi_gian_tao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	FOREIGN KEY (ma_vai_tro) REFERENCES vai_tro(ma_vai_tro)
);

CREATE TABLE nhan_vien (
    ma_nhan_vien nvarchar(15) NOT NULL PRIMARY KEY,
    ten_nhan_vien nvarchar(100),
    chuc_vu nvarchar(100) ,
	FOREIGN KEY (ma_nhan_vien) REFERENCES nguoi_dung(ma_nguoi_dung)
);

CREATE TABLE khach_hang (
  ma_khach_hang nvarchar(15) NOT NULL PRIMARY KEY ,
  ten_khach_hang nvarchar(100) ,
  dia_chi nvarchar(100) ,
  dien_thoai nvarchar(100) ,
  hinh_anh nvarchar(100) ,
  ghi_chu nvarchar(500),
  FOREIGN KEY (ma_khach_hang) REFERENCES nguoi_dung(ma_nguoi_dung)
);

CREATE TABLE loai_mon_an (
  ma_loai nvarchar(15) NOT NULL PRIMARY KEY,
  ten_loai varchar(100) ,
  mo_ta varchar(500) ,
  hinh varchar(100) 
);

CREATE TABLE mon_an (
  ma_mon nvarchar(15) NOT NULL PRIMARY KEY,
  ma_loai nvarchar(15) NOT NULL ,
  ten_mon varchar(100) ,
  noi_dung_tom_tat nvarchar(500) ,
  noi_dung_chi_tiet nvarchar(500) ,
  don_gia money,
  don_gia_khuyen_mai money ,
  khuyen_mai nvarchar(100) ,
  hinh varchar(100) ,
  ngay_cap_nhat date ,
  dvt varchar(100) ,
  trong_ngay int, 
  FOREIGN KEY (ma_loai) REFERENCES loai_mon_an (ma_loai),
);

CREATE TABLE hoa_don (
  ma_hoa_don nvarchar(15) NOT NULL PRIMARY KEY,
  ma_khach_hang nvarchar(15) NOT NULL ,
  ma_nhan_vien nvarchar(15) NOT NULL,
  ngay_dat date ,
  tong_tien money ,
  tien_dat_coc money ,
  con_lai money ,
  hinh_thuc_thanh_toan nvarchar(100) ,
  ghi_chu nvarchar(500), 
  FOREIGN KEY (ma_khach_hang) REFERENCES khach_hang (ma_khach_hang),
  FOREIGN KEY (ma_nhan_vien) REFERENCES nhan_vien (ma_nhan_vien)
);

CREATE TABLE chi_tiet_hoa_don (
  ma_hoa_don nvarchar(15) NOT NULL,
  ma_mon nvarchar(15) NOT NULL,
  so_luong int,
  don_gia money,
  mon_thuc_don int NOT NULL, 
  PRIMARY KEY (ma_hoa_don,ma_mon,mon_thuc_don),
  FOREIGN KEY (ma_hoa_don) REFERENCES hoa_don (ma_hoa_don),
  FOREIGN KEY (ma_mon) REFERENCES mon_an (ma_mon),
);

GO
------------------------------------ NỘI DUNG -------------------------------------
-- Bảng vai_tro
INSERT INTO vai_tro VALUES
(N'QL', N'quan_ly'),
(N'NV', N'nhan_vien'),
(N'KH', N'khach_hang');

-- Bảng nguoi_dung
INSERT INTO nguoi_dung VALUES
(N'NV01', N'ngocthy', N'123', N'thy@gmail.com', N'QL'),
(N'NV02', N'nguyenkhang', N'123', N'khang@gmail.com', N'NV'),
(N'NV03', N'haidang', N'123', N'dang@gmail.com', N'NV'),
(N'NV04', N'vana', N'123', N'a@gmail.com', N'NV'),
(N'NV05', N'nhiepba', N'123', N'ba@gmail.com', N'QL'),
			-- khách hàng
(N'KH01', N'haiyen', N'123', N'yennh@gmail.com', N'KH'),
(N'KH02', N'ngocthykh', N'123', N'thylhn@gmail.com', N'KH'),
(N'KH03', N'quetram', N'123', N'tramlhq@gmail.com', N'KH'),
(N'KH04', N'thientai', N'123', N'taitt@gmail.com', N'KH'),
(N'KH05', N'minhtai', N'123', N'taitm@gmail.com', N'KH'),
(N'KH06', N'xuantu', N'123', N'tulx@gmail.com', N'KH'),
(N'KH07', N'xuantrinh', N'123', N'trinhlx@gmail.com', N'KH'),
(N'KH08', N'thichon', N'123', N'chonlh@gmail.com', N'KH'),
(N'KH09', N'tantrieu', N'123', N'trieuvt@gmail.com', N'KH'),
(N'KH10', N'thanhphong', N'123', N'phongvt@gmail.com', N'KH'),
(N'KH11', N'kimcuc', N'123', N'cucnk@gmail.com', N'KH'),
(N'KH12', N'thimy', N'123', N'myht@gmail.com', N'KH'),
(N'KH13', N'lebtien', N'123', N'tienhlb@gmail.com', N'KH'),
(N'KH14', N'tuyetdiem', N'123', N'diemht@gmail.com', N'KH'),
(N'KH15', N'thaovy', N'123', N'vyvpt@gmail.com', N'KH'),
(N'KH16', N'tuongvy', N'123', N'vyvpt2@gmail.com', N'KH');

-- Bảng nhan_vien
INSERT INTO nhan_vien VALUES
(N'NV01', N'Lê Hà Ngọc Thy', N'Quản Lý'),
(N'NV02', N'Lê Nguyên Khang', N'Nhân Viên Phục Vụ'),
(N'NV03', N'Phạm Hải Đăng', N'Nhân Viên Bếp'),
(N'NV04', N'Nguyễn Văn A', N'Nhân Viên Phục Vụ'),
(N'NV05', N'Địch Lệ Nhiệt Ba', N'Quản lý');

-- Bảng khach_hang
INSERT INTO khach_hang VALUES
(N'KH01', N'Nguyễn Hải Yến', N'140 Lê Trọng Tấn', N'0812345678', N'hinh1.jpg', N''),
(N'KH02', N'Lê Hà Ngọc Thy', N'743 Nguyễn Ảnh Thủ', N'0334909', N'hinh2.jpg', N'la sinh vien HUIT'),
(N'KH03', N'Le Ha Que tram', N'534 Nguyễn Ảnh Thủ', N'081234566', N'hinh3.jpg', N''),
(N'KH04', N'Tran Thien Tai', N'998 Lê Thị Riêng', N'0123459233', N'hinh4.jpg', N'la sinh vien Hutech'),
(N'KH05', N'Tran Minh Tai', N'123 Hóc Môn', N'05532125', N'hinh5.jpg', N'Hoa khôi trường HUIT'),
(N'KH06', N'Lê Xuân Tú', N'123 Lê Văn Khương', N'0123456789', N'hinh6.jpg', N'La hs truong THCS Nguyễn Trung Trực'),
(N'KH07', N'Lê Xuân Trinh', N'744 Nguyễn Ảnh Thủ', N'0249123456', N'hinh7.jpg', N'Là Nam Vương Campuchia'),
(N'KH08', N'Lê Thị Chon', N'1234/12 Củ Chi', N'015090508', N'hinh8.jpg', N'Là diễn viên siêu đỉnh'),
(N'KH09', N'Võ Tấn Triều', N'3/5 Không Biết', N'0332253', N'hinh9.jpg', N'siêu cấp đỉnh cao thờ ơ'),
(N'KH10', N'Võ Thanh Phong', N'123 Đồng Tháp 10', N'055777777', N'hinh10.jpg', N'thích gái dẹp'),
(N'KH11', N'Nguyễn Kim Cúc', N'77/7 Đồng tháp', N'0775672', N'hinh11.jpg', N'thích phi công trẻ'),
(N'KH12', N'Hà Thị Mỹ', N'15768 Lê Trọng tấn', N'09122135', N'hinh12.jpg', N''),
(N'KH13', N'Hà Lệ Băng Tiên', N'743/1/1 Nguyễn Ảnh Thủ', N'012339909', N'hinh13.jpg', N''),
(N'KH14', N'Hà Tuyết Diễm', N'123/68 Lê Trọng Tấn', N'0852570960', N'hinh14.jpg', N'da mặt rất đẹp'),
(N'KH15', N'Võ Phạm Thảo Vy', N'568 Lê Trọng Tấn', N'0123456789', N'hinh15.jpg', N'thích trai anime'),
(N'KH16', N'Võ Phạm Tường Vy', N'123 Biên Giới QG', N'012364123', N'hinh16.jpg', N'');

-- Bảng loai_mon_an
INSERT INTO loai_mon_an VALUES
(N'LM01', N'Món Canh', N'Có nước chan', N'Canh1.jpg'),
(N'LM02', N'Món Cơm', N'Gạo tẻ', N'Com1.jpg'),
(N'LM03', N'Món mặn', N'Món mặn', N'mon_man.jpg'),
(N'LM04', N'Ăn Sáng', N'Ăn Sáng', N'An_sang.jpg'),
(N'LM05', N'Món Súp', N'Món Súp', N'sup.jpg'),
(N'LM06', N'Món gỏi', N'Món gỏi', N'Goi.jpg'),
(N'LM07', N'Món Sào', N'Món Sào', N'MonSao.jpg'),
(N'LM08', N'Tráng miệng', N'Tráng miệng', N'TrangMieng.jpg');

-- Bảng mon_an
INSERT INTO mon_an VALUES
(N'MA01', N'LM02', N'Cơm Tấm', N'Cơn Tấm từ lâu đã là 1 nét đặc trưng của ẩm thực Việt', N'Cơm tấm', 25000, 0, N'Nước ngọt, khăn lạnh ', N'ComTam.jpg', '2018-04-17', N'Đĩa', 1),
(N'MA02', N'LM02', N'Cơm gà', N'Cơm gà là món ăn được chế biến với hình thức gà chiên nước mắm siêu ngon ', N'Cơm gà ', 35000, 30000, N'Nước ngọt, khăn lạnh ', N'ComGa.jpg', '2018-03-13', N'Đĩa', 1),
(N'MA03', N'LM02', N'Cơm Sườn', N'Cơm Sườn là món ăn đặc sản của miền Nam, Việt Nam', N'Cơm Sường Cọng / miếng', 20000, 0, N'Nước ngọt, khăn lạnh ', N'ComSuon.jpg', '2018-03-19', N'Đĩa', 1),
(N'MA04', N'LM02', N'Cơm Chay', N'Cơm chay là món ăn bỏ dưỡng làm từ cây trồng và không sử dụng các loại thịt. Ăn chay có thể giúp ta giảm cân. và giúp ta tu niệm =)))', N'Cơm chay', 10000, 0, N'Nước ngọt, khăn lạnh ', N'ComChay.jpg', '2018-04-17', N'Đĩa', 1),
(N'MA05', N'LM01', N'Canh Rau Ngọt', N'Canh rau Ngọt là món ăn làm từ rau ngọt, bổ dưỡng tốt cho sức khỏe. Nhưng không dành cho những ai không biết ăn rau. Nếu không biết ăn rau mà vẫn muốn ăn rau thì hãy sử dụng kẹo rau củ Kera của Hằng D', N'Rau ngót thịt bằm', 15000, 0, N'Nước ngọt, khăn lạnh ', N'RauNgot.jpg', '2018-03-13', N'Chén', 1),
(N'MA06', N'LM01', N'Rau Dền', N'Rau Dền là món ăn làm từ rau, bổ dưỡng tốt cho sức khỏe. Nhưng không dành cho những ai không biết ăn rau. Nếu không biết ăn rau mà vẫn muốn ăn rau thì hãy sử dụng kẹo rau củ Kera của Hằng Du Mục và Qu', N'Rau dền, thịt bằm', 15000, 0, N'Nước ngọt', N'RauDen.jpg', '2018-04-09', N'Tô', 1),
(N'MA07', N'LM01', N'Canh Khổ Qua', N'Canh Khổ Qua nhồi thịt. Cho những ai thích sự đắng cay', N'Canh Khổ Qua nhồi thịt.', 20000, 0, N'Nước ngọt, khăn lạnh ', N'KhoQua.jpg', '2018-04-18', N'Tô', 1),
(N'MA08', N'LM01', N'Canh chua cá lóc', N'Canh chua cá lóc', N'Canh chua cá lóc cho dân miền Tây', 25000, 0, N'Nước ngọt, khăn lạnh', N'CanhChua.jpg', '2018-03-18', N'tô', 1),
(N'MA09', N'LM01', N'Canh Tần ô', N'Canh tần Ô thịt bằm với hành lá', N'Canh tần Ô thịt bằm ', 15000, 0, N'Nước ngọt, khăn lạnh', N'canhto.jpg', '2018-04-08', N'tô', 1),
(N'MA10', N'LM03', N'Cá lóc kho', N'Cá lóc kho mắm + dĩa rau cà chua siêu ngon', N'Cá lóc kho mắm tôm', 20000, 0, N'Nước ngọt, khăn lạnh', N'CaKho.jpg', '2018-04-09', N'Đĩa', 2),
(N'MA11', N'LM03', N'Thịt Kho Tiêu', N'Thịt Kho Tiêu ăn ngon hơn khi có cà chua nha', N'Thịt Kho Tiêu với cơm trắng', 15000, 0, N'Nước ngọt, khăn lạnh', N'ThitKhoTieu.jpg', '2018-04-01', N'đĩa', 1),
(N'MA12', N'LM03', N'Thịt Rang Tôm', N'Thịt Rang Tôm có dưa leo kèm theo', N'Thịt Rang Tôm cháy cạnh', 25000, 0, N'Nước ngọt, khăn lạnh', N'ThitTom.jpg', '2018-04-24', N'đĩa', 1),
(N'MA13', N'LM03', N'Gà Kho Gừng', N'Gà Kho Gừng + cà chua ăn kèm', N'Gà Kho Gừng với nấm kim châm', 15000, 0, N'Nước ngọt, khăn lạnh', N'GaGung.jpg', '2018-04-25', N'Đĩa', 1),
(N'MA14', N'LM03', N'Gà Kho Sả', N'Gà Kho Sả', N'Gà Kho Sả ớt siêu cayyyy', 15000, 0, N'Nước ngọt, khăn lạnh', N'GaSa.jpg', '2018-04-26', N'đĩa', 1),
(N'MA15', N'LM07', N'Cải xào chua ngọt', N'Cải xào chua ngọt', N'Cải xào chua ngọt với mắm nhĩ', 15000, 2000, N'Nước ngọt', N'hinh1.jpg', '2018-04-10', N'tô', 2),
(N'MA16', N'LM04', N'Mì Trộn', N'Mì Trộn', N'Mì Trộn thêm trứng', 25000, 2000, N'Nước ngọt', N'hinh2.jpg', '2018-04-07', N'đĩa', 4),
(N'MA17', N'LM04', N'Mì Trộn', N'Mì Trộn', N'Mì Trộn với xúc xích', 25000, 5000, N'0', N'hinh3.jpg', '2018-03-12', N'đĩa', 3),
(N'MA18', N'LM04', N'Mì Trộn', N'Mì Trộn có cà chua và dưa leo kèm theo', N'Mì Trộn với Trứng, xúc xích', 30000, 3000, N'Nước ngọt', N'hinh4.jpg', '2018-04-09', N'đĩa', 1),
(N'MA19', N'LM05', N'Súp mặn', N'Súp mặn', N'Súp mặn', 10000, 3000, N'Khăn lạnh', N'hinh5.jpg', '2018-04-09', N'ly', 2),
(N'MA20', N'LM05', N'Súp Cua', N'Súp Cua', N'Súp Cua (có hành)', 12000, 1000, N'Khăn lạnh', N'hinh6.jpg', '2018-04-06', N'ly', 5),
(N'MA21', N'LM06', N'Gỏi xoài', N'Gỏi xoài', N'Gỏi xoài với mắm đường siêu siêu ngon', 20000, 0, N'Khăn lạnh', N'hinh7.jpg', '2018-03-12', N'đĩa', 9),
(N'MA22', N'LM06', N'Gỏi Đu Đủ', N'Gỏi Đu Đủ', N'Gỏi Đu Đủ', 14000, 14000, N'Khăn lạnh', N'hinh8.jpg', '2025-03-20', N'đĩa', 2),
(N'MA23', N'LM06', N'Gỏi Hũ Dừa', N'Gỏi Hũ Dừa siêu ngon ', N'Gỏi Hũ Dừa bá cháy bò chét', 18000, 0, N'0', N'hinh9.jpg', '2018-03-17', N'đĩa', 2),
(N'MA24', N'LM07', N'Rau Muống Xào', N'Rau Muống Xào dưa leo', N'Rau Muống Xào mắm chua ngọt', 8000, 1000, N'0', N'hinh10.jpg', '2018-03-20', N'đĩa', 2),
(N'MA25', N'LM08', N'Trái cây', N'Trái cây', N'Đu đủ, dưa hấu, mãng cầu, xoài', 30000, 8000, N'Khăn lạnh', N'hinh11.jpg', '2018-03-19', N'đĩa', 1),
(N'MA26', N'LM08', N'Rau câu', N'Rau câu', N'Rau câu bảy màu', 25000, 0, N'0', N'hinh12.jpg', '2018-03-13', N'đĩa', 4);

INSERT INTO hoa_don VALUES
(N'HD01', N'KH13', N'NV01', '2018-04-08', 200000, 50000, 150000, N'tiền mặt', N''),
(N'HD02', N'KH02', N'NV02', '2018-04-09', 53000, 3000, 50000, N'tiền mặt', N''),
(N'HD03', N'KH08', N'NV02', '2018-03-06', 9097700, 550900, 10000000, N'tiền mặt', N'nợ cũ chưa trả'),
(N'HD04', N'KH06', N'NV03', '2018-03-11', 23000, 0, 0, N'chuyển khoản', N''),
(N'HD05', N'KH07', N'NV02', '2018-03-20', 779000, 0, 0, N'tiền mặt', N''),
(N'HD06', N'KH14', N'NV01', '2018-03-05', 23000, 0, 0, N'chuyển khoản', N''),
(N'HD07', N'KH12', N'NV03', '2018-04-10', 60000, 1200, 2000, N'chuyển khoản', N''),
(N'HD08', N'KH03', N'NV04', '2018-04-10', 520000, 2000, 12000, N'tiền mặt', N''),
(N'HD09', N'KH08', N'NV04', '2018-03-11', 5677000, 4777000, 1277000, N'chuyển khoản', N'nợ quá nhiều'),
(N'HD10', N'KH05', N'NV05', '2018-03-19', 534000, 42000, 24000, N'chuyển khoản', N''),
(N'HD11', N'KH01', N'NV05', '2018-04-17', 99600, 5000, 15300, N'chuyển khoản', N''),
(N'HD12', N'KH08', N'NV04', '2018-03-13', 22000, 1000, 1200, N'chuyển khoản', N''),
(N'HD13', N'KH15', N'NV02', '2018-04-09', 12000, 1000, 0, N'tiền mặt', N''),
(N'HD14', N'KH03', N'NV03', '2018-04-11', 12000, 2000, 0, N'chuyển khoản', N''),
(N'HD15', N'KH09', N'NV05', '2018-03-13', 52777000, 527000, 2370000, N'chuyển khoản', N'thiếu nợ');

INSERT INTO chi_tiet_hoa_don VALUES
(N'HD01', N'MA02', 5, 40000, 1),
(N'HD01', N'MA05', 3, 28000, 1),
(N'HD01', N'MA08', 9, 55000, 1),
(N'HD02', N'MA04', 5, 20000, 1),
(N'HD06', N'MA04', 2, 25000, 18),
(N'HD07', N'MA03', 5, 50000, 2),
(N'HD09', N'MA05', 5, 15000, 2),
(N'HD13', N'MA09', 9, 12000, 9),
(N'HD14', N'MA17', 5, 23000, 2);



