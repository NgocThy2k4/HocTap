// views/admin/QuanLyKhachHangPage.dart
import 'package:flutter/material.dart';
// import 'package:sqlite3/sqlite3.dart'; // Thường không cần import này trực tiếp
import '../../database/DatabaseHelper.dart';
import '../../models/KhachHang.dart';
import 'package:flutter/services.dart'; // Cho TextInputFormatter nếu cần

class QuanLyKhachHangPage extends StatefulWidget {
  @override
  _QuanLyKhachHangPageState createState() => _QuanLyKhachHangPageState();
}

class _QuanLyKhachHangPageState extends State<QuanLyKhachHangPage> {
  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;
  final TextEditingController _searchController = TextEditingController();
  List<KhachHang> _khachHangList = [];
  List<KhachHang> _filteredKhachHangList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadKhachHang();
    _searchController.addListener(_filterKhachHang);
  }

  Future<void> _loadKhachHang() async {
    setState(() => _isLoading = true);
    try {
      // Sử dụng hàm getAllKhachHang đã có sẵn trong DatabaseHelper
      _khachHangList = await _dbHelper.getAllKhachHang();
      _filteredKhachHangList = List.from(_khachHangList); // Tạo bản sao
    } catch (e) {
      debugPrint('Lỗi khi tải danh sách khách hàng: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi tải dữ liệu: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterKhachHang() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredKhachHangList =
          _khachHangList.where((kh) {
            final ten =
                kh.tenKhachHang.toLowerCase(); // tenKhachHang là required
            final ma = kh.maKhachHang.toLowerCase(); // Thêm tìm kiếm theo mã
            return ten.contains(query) || ma.contains(query);
          }).toList();
    });
  }

  Future<void> _showAddEditDialog({KhachHang? khachHang}) async {
    final bool isEditing = khachHang != null;
    final TextEditingController maController = TextEditingController(
      text: isEditing ? khachHang.maKhachHang : '',
    );
    final TextEditingController tenController = TextEditingController(
      text: khachHang?.tenKhachHang,
    );
    final TextEditingController diaChiController = TextEditingController(
      text: khachHang?.diaChi,
    );
    final TextEditingController dienThoaiController = TextEditingController(
      text: khachHang?.dienThoai,
    );
    final TextEditingController ghiChuController = TextEditingController(
      text: khachHang?.ghiChu,
    );

    // Tạo mã mới nếu thêm khách hàng
    if (!isEditing) {
      final nextIdNum = await _dbHelper.getNextMaNguoiDung(
        'KH',
      ); // Sử dụng hàm đã có
      maController.text =
          'KH${nextIdNum.toString().padLeft(2, '0')}'; // Định dạng KH01, KH02...
    }

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              isEditing ? 'Sửa Khách Hàng' : 'Thêm Khách Hàng',
              style: TextStyle(color: Color(0xFFE91E63)),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: maController,
                    readOnly: true, // Mã khách hàng không cho phép chỉnh sửa
                    decoration: InputDecoration(
                      labelText: 'Mã khách hàng',
                      filled: true,
                      fillColor:
                          Colors.grey[200], // Màu nền xám cho trường readOnly
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: tenController,
                    decoration: InputDecoration(
                      labelText: 'Tên khách hàng',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: diaChiController,
                    decoration: InputDecoration(
                      labelText: 'Địa chỉ',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: dienThoaiController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Có thể thêm inputFormatters nếu muốn chỉ nhập số
                    // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: ghiChuController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Ghi chú',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy', style: TextStyle(color: Color(0xFFE91E63))),
              ),
              ElevatedButton(
                // Dùng ElevatedButton để làm nổi bật nút Lưu
                onPressed: () async {
                  if (tenController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Vui lòng nhập tên khách hàng.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final newKhachHang = KhachHang(
                    maKhachHang: maController.text, // Lấy mã từ controller
                    tenKhachHang: tenController.text,
                    diaChi: diaChiController.text,
                    dienThoai: dienThoaiController.text,
                    hinhAnh:
                        khachHang?.hinhAnh ??
                        'default_khach_hang.jpg', // Giữ nguyên ảnh hoặc gán default
                    ghiChu: ghiChuController.text,
                  );

                  try {
                    if (isEditing) {
                      await _dbHelper.updateKhachHang(newKhachHang.toMap());
                    } else {
                      await _dbHelper.insertKhachHang(newKhachHang.toMap());
                    }

                    _loadKhachHang(); // Tải lại danh sách sau khi cập nhật
                    Navigator.pop(context); // Đóng dialog

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEditing
                              ? 'Cập nhật khách hàng thành công.'
                              : 'Thêm khách hàng thành công.',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    debugPrint('Lỗi khi lưu khách hàng: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lỗi khi lưu khách hàng: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFB2D9), // Màu hồng cho nút Lưu
                  foregroundColor: Colors.white,
                ),
                child: Text('Lưu'),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteKhachHang(String maKhachHang) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Xác nhận xóa',
              style: TextStyle(color: Color(0xFFE91E63)),
            ),
            content: Text('Bạn có chắc muốn xóa khách hàng này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Hủy', style: TextStyle(color: Color(0xFFE91E63))),
              ),
              ElevatedButton(
                // Dùng ElevatedButton cho nút Xóa
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Màu đỏ cho nút Xóa
                  foregroundColor: Colors.white,
                ),
                child: Text('Xóa'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await _dbHelper.deleteKhachHang(maKhachHang);
        _loadKhachHang(); // Tải lại danh sách
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa khách hàng.'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        debugPrint('Lỗi khi xóa khách hàng: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi xóa khách hàng: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản Lý Khách Hàng',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFFFCE4EC),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm khách hàng...',
                prefixIcon: Icon(Icons.search, color: Color(0xFFE91E63)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE91E63),
                      ),
                    )
                    : _filteredKhachHangList.isEmpty
                    ? Center(child: Text('Không có khách hàng nào.'))
                    : ListView.builder(
                      itemCount: _filteredKhachHangList.length,
                      itemBuilder: (context, index) {
                        final kh = _filteredKhachHangList[index];
                        return Card(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/HinhAnh/KhachHang/${kh.hinhAnh ?? 'default_khach_hang.jpg'}',
                              ),
                              onBackgroundImageError: (exception, stackTrace) {
                                debugPrint(
                                  'Lỗi tải ảnh khách hàng: ${kh.hinhAnh ?? 'default_khach_hang.jpg'}, Lỗi: $exception',
                                );
                              },
                            ),
                            title: Text(
                              kh.tenKhachHang, // Đảm bảo tenKhachHang không null
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${kh.dienThoai ?? ''}\n${kh.diaChi ?? ''}',
                            ),
                            trailing: Row(
                              // <-- KHÔNG CÒN LỖI ĐỎ Ở ĐÂY NỮA
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed:
                                      () => _showAddEditDialog(khachHang: kh),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await _deleteKhachHang(kh.maKhachHang);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFFE91E63),
      ),
    );
  }
}
