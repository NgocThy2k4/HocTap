// views/admin/QuanLyNhanVienPage.dart

import 'package:flutter/material.dart';
import '../../database/DatabaseHelper.dart';
import '../../models/NhanVien.dart';

class QuanLyNhanVienPage extends StatefulWidget {
  @override
  _QuanLyNhanVienPageState createState() => _QuanLyNhanVienPageState();
}

class _QuanLyNhanVienPageState extends State<QuanLyNhanVienPage> {
  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;
  final TextEditingController _searchController = TextEditingController();
  List<NhanVien> _nhanVienList = [];
  List<NhanVien> _filteredNhanVienList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNhanVien();
    _searchController.addListener(_filterNhanVien);
  }

  Future<void> _loadNhanVien() async {
    setState(() => _isLoading = true);
    try {
      _nhanVienList = await _dbHelper.getAllNhanVien();
      _filteredNhanVienList = _nhanVienList;
    } catch (e) {
      debugPrint('Lỗi khi tải dữ liệu nhân viên: $e');
      if (mounted) {
        // Kiểm tra mounted trước khi dùng context sau async
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi tải dữ liệu: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterNhanVien() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNhanVienList =
          _nhanVienList.where((nv) {
            final ten = nv.tenNhanVien?.toLowerCase() ?? '';
            return ten.contains(query);
          }).toList();
    });
  }

  Future<void> _showAddEditDialog({NhanVien? nhanVien}) async {
    final bool isEditing = nhanVien != null;
    final TextEditingController maNhanVienController = TextEditingController(
      text:
          isEditing
              ? nhanVien!.maNhanVien
              : 'NV${DateTime.now().millisecondsSinceEpoch}', // Mã NV tạm thời
    );
    final TextEditingController tenController = TextEditingController(
      text: nhanVien?.tenNhanVien,
    );
    final TextEditingController chucVuController = TextEditingController(
      text: nhanVien?.chucVu,
    );
    final TextEditingController diaChiController = TextEditingController(
      text: nhanVien?.diaChi,
    );
    final TextEditingController dienThoaiController = TextEditingController(
      text: nhanVien?.dienThoai,
    );
    final TextEditingController ghiChuController = TextEditingController(
      text: nhanVien?.ghiChu,
    );
    final TextEditingController hinhAnhController = TextEditingController(
      text: nhanVien?.hinhAnh,
    );

    // Thêm logic để tạo mã nhân viên mới dạng NV01, NV02,...
    if (!isEditing) {
      final nextIdNum =
          await _dbHelper.getNextMaNhanVien(); // Giả sử có hàm này
      maNhanVienController.text =
          'NV${nextIdNum.toString().padLeft(2, '0')}'; // NV01, NV02...
    }

    await showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            // Đổi tên context trong builder để tránh nhầm lẫn
            title: Text(
              isEditing ? 'Sửa Nhân Viên' : 'Thêm Nhân Viên',
              style: TextStyle(color: Color(0xFFE91E63)),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: maNhanVienController,
                    readOnly: true, // Mã nhân viên không cho chỉnh sửa
                    decoration: InputDecoration(
                      labelText: 'Mã nhân viên',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: tenController,
                    decoration: InputDecoration(
                      labelText: 'Tên nhân viên',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: chucVuController,
                    decoration: InputDecoration(
                      labelText: 'Chức vụ',
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: hinhAnhController,
                    decoration: InputDecoration(
                      labelText: 'Tên file hình ảnh (VD: avatar.png)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: ghiChuController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Ghi chú',
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
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('Hủy', style: TextStyle(color: Color(0xFFE91E63))),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (tenController.text.isEmpty ||
                      chucVuController.text.isEmpty ||
                      diaChiController.text.isEmpty ||
                      dienThoaiController.text.isEmpty) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      // Sử dụng dialogContext
                      SnackBar(
                        content: Text(
                          'Vui lòng nhập đầy đủ thông tin bắt buộc.',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final newNhanVien = NhanVien(
                    maNhanVien: maNhanVienController.text,
                    tenNhanVien: tenController.text,
                    chucVu: chucVuController.text,
                    diaChi: diaChiController.text,
                    dienThoai: dienThoaiController.text,
                    hinhAnh:
                        hinhAnhController.text.isNotEmpty
                            ? hinhAnhController.text
                            : 'default_nv.png', // Default image
                    ghiChu: ghiChuController.text,
                  );

                  try {
                    if (isEditing) {
                      await _dbHelper.updateNhanVien(newNhanVien.toMap());
                    } else {
                      await _dbHelper.insertNhanVien(newNhanVien.toMap());
                    }
                    _loadNhanVien();
                    Navigator.pop(dialogContext); // Sử dụng dialogContext
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      // Sử dụng dialogContext
                      SnackBar(
                        content: Text(
                          isEditing
                              ? 'Cập nhật nhân viên thành công.'
                              : 'Thêm nhân viên thành công.',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    debugPrint('Lỗi khi lưu nhân viên: $e');
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      // Sử dụng dialogContext
                      SnackBar(
                        content: Text('Lỗi khi lưu nhân viên: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                ),
                child: Text('Lưu'),
              ),
            ],
          ),
    );
  }

  // Hàm _deleteNhanVien mới nhận BuildContext làm tham số
  Future<void> _deleteNhanVien(BuildContext context, String maNhanVien) async {
    final confirm = await showDialog<bool>(
      context: context, // Sử dụng context được truyền vào
      builder:
          (dialogContext) => AlertDialog(
            title: Text(
              'Xác nhận xóa',
              style: TextStyle(color: Color(0xFFE91E63)),
            ),
            content: Text('Bạn có chắc muốn xóa nhân viên này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text('Hủy', style: TextStyle(color: Color(0xFFE91E63))),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text('Xóa', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
    if (confirm == true) {
      try {
        await _dbHelper.deleteNhanVien(maNhanVien);
        _loadNhanVien();
        if (mounted) {
          // Kiểm tra mounted trước khi dùng context sau async
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã xóa nhân viên.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        debugPrint('Lỗi khi xóa nhân viên: $e');
        if (mounted) {
          // Kiểm tra mounted trước khi dùng context sau async
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi xóa nhân viên: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
          'Quản Lý Nhân Viên',
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
                hintText: 'Tìm kiếm nhân viên...',
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
                    : _filteredNhanVienList.isEmpty
                    ? Center(child: Text('Không có nhân viên nào.'))
                    : ListView.builder(
                      itemCount: _filteredNhanVienList.length,
                      itemBuilder: (context, index) {
                        final nv = _filteredNhanVienList[index];
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
                                'assets/HinhAnh/NhanVien/${nv.hinhAnh ?? 'default_nv.png'}', // Default image
                              ),
                              onBackgroundImageError: (exception, stackTrace) {
                                debugPrint(
                                  'Lỗi tải ảnh nhân viên: ${nv.hinhAnh ?? 'default_nv.png'}, Lỗi: $exception',
                                );
                              },
                            ),
                            title: Text(
                              nv.tenNhanVien ?? 'Chưa có tên',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${nv.chucVu ?? ''} - ${nv.dienThoai ?? ''}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed:
                                      () => _showAddEditDialog(nhanVien: nv),
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    // Gọi hàm _deleteNhanVien mới, truyền context vào
                                    await _deleteNhanVien(
                                      context,
                                      nv.maNhanVien,
                                    );
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
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
