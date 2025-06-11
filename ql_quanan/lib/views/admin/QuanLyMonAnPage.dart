// views/admin/QuanLyMonAnPage.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart'
    as p; // Đảm bảo đã thêm alias để tránh xung đột 'context'

import '../../database/DatabaseHelper.dart';
import '../../models/MonAn.dart';
import '../../models/LoaiMonAn.dart'; // Import LoaiMonAn model nếu bạn dùng trực tiếp
import '../../controllers/CartController.dart';

class QuanLyMonAnPage extends StatefulWidget {
  @override
  _QuanLyMonAnPageState createState() => _QuanLyMonAnPageState();
}

class _QuanLyMonAnPageState extends State<QuanLyMonAnPage> {
  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _monAnList = [];
  List<Map<String, dynamic>> _filteredMonAnList = [];
  List<Map<String, dynamic>> _loaiMonAnList =
      []; // Danh sách loại món ăn cho Dropdown
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterMonAn);
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      _monAnList = await _dbHelper.getAllMonAn();
      _filteredMonAnList = _monAnList;
      _loaiMonAnList = await _dbHelper.getAllLoaiMonAn();
      print('DEBUG: Loaded LoaiMonAnList: $_loaiMonAnList'); // Kiểm tra dữ liệu
    } catch (e) {
      debugPrint('Lỗi khi tải dữ liệu món ăn hoặc loại món ăn: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi khi tải dữ liệu: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterMonAn() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMonAnList =
          _monAnList.where((monAn) {
            final tenMon = monAn['ten_mon'].toString().toLowerCase();
            return tenMon.contains(query);
          }).toList();
    });
  }

  Future<void> _showAddEditDialog({Map<String, dynamic>? monAn}) async {
    final bool isEditing = monAn != null;
    final TextEditingController maMonController = TextEditingController(
      text: isEditing ? monAn['ma_mon'] : '', // Lấy ma_mon
    );
    final TextEditingController tenController = TextEditingController(
      text: monAn?['ten_mon'],
    );
    final TextEditingController donGiaController = TextEditingController(
      text: monAn?['don_gia']?.toString(),
    );
    String? selectedLoaiMonAn = monAn?['ma_loai'];
    final TextEditingController hinhController = TextEditingController(
      text: monAn?['hinh'],
    );

    // Tạo mã món mới nếu thêm mới
    if (!isEditing) {
      final nextIdNum = await _dbHelper.getNextMaMonAn(); // Giả sử có hàm này
      maMonController.text =
          'MA${nextIdNum.toString().padLeft(2, '0')}'; // MA001, MA002...
    }

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              isEditing ? 'Sửa Món Ăn' : 'Thêm Món Ăn',
              style: TextStyle(color: Color(0xFFE91E63)),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: maMonController,
                    readOnly: true, // Mã món ăn không cho chỉnh sửa
                    decoration: InputDecoration(
                      labelText: 'Mã món ăn',
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
                      labelText: 'Tên món ăn',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: donGiaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Đơn giá',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedLoaiMonAn,
                    decoration: InputDecoration(
                      labelText: 'Loại món ăn',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items:
                        _loaiMonAnList
                            .map(
                              (loai) => DropdownMenuItem(
                                value:
                                    loai['ma_loai']
                                        as String, // Đảm bảo kiểu String
                                child: Text(
                                  loai['ten_loai'] as String,
                                ), // Đảm bảo kiểu String
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        // Cập nhật state của dialog
                        selectedLoaiMonAn = value;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: hinhController,
                    decoration: InputDecoration(
                      labelText: 'Tên file hình ảnh (VD: burger.png)',
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
                // Dùng ElevatedButton cho nút lưu
                onPressed: () async {
                  if (tenController.text.isEmpty ||
                      donGiaController.text.isEmpty ||
                      selectedLoaiMonAn == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Vui lòng nhập đầy đủ thông tin.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final newMonAnData = {
                    // Đổi tên biến để tránh nhầm lẫn
                    'ma_mon': maMonController.text, // Sử dụng ma_mon
                    'ma_loai': selectedLoaiMonAn,
                    'ten_mon': tenController.text,
                    'don_gia': double.tryParse(donGiaController.text) ?? 0.0,
                    'hinh':
                        hinhController.text.isNotEmpty
                            ? hinhController.text
                            : null,
                    // Có thể thêm các trường khác nếu cần, ví dụ:
                    // 'noi_dung_tom_tat': '...',
                    // 'noi_dung_chi_tiet': '...',
                    // 'ngay_cap_nhat': DateTime.now().toIso8601String(),
                  };

                  try {
                    if (isEditing) {
                      await _dbHelper.updateMonAn(newMonAnData);
                    } else {
                      await _dbHelper.insertMonAn(newMonAnData);
                    }

                    _loadData(); // Tải lại dữ liệu
                    Navigator.pop(context); // Đóng dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEditing
                              ? 'Cập nhật món ăn thành công.'
                              : 'Thêm món ăn thành công.',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    debugPrint('Lỗi khi lưu món ăn: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lỗi khi lưu món ăn: ${e.toString()}'),
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

  Future<void> _deleteMonAn(String maMon) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Xác nhận xóa',
              style: TextStyle(color: Color(0xFFE91E63)),
            ),
            content: Text('Bạn có chắc muốn xóa món ăn này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Hủy', style: TextStyle(color: Color(0xFFE91E63))),
              ),
              ElevatedButton(
                // Dùng ElevatedButton
                onPressed: () => Navigator.pop(context, true),
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
        await _dbHelper.deleteMonAn(maMon);
        _loadData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa món ăn.'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        debugPrint('Lỗi khi xóa món ăn: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi xóa món ăn: ${e.toString()}'),
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
          'Quản Lý Món Ăn',
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
                hintText: 'Tìm kiếm món ăn...',
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
                    : _filteredMonAnList.isEmpty
                    ? Center(child: Text('Không có món ăn nào.'))
                    : ListView.builder(
                      itemCount: _filteredMonAnList.length,
                      itemBuilder: (context, index) {
                        final monAn = _filteredMonAnList[index];
                        // Tìm loại món ăn từ danh sách _loaiMonAnList đã tải
                        final loaiMonAn = _loaiMonAnList.firstWhere(
                          (loai) => loai['ma_loai'] == monAn['ma_loai'],
                          orElse: () => {'ten_loai': 'Không xác định'},
                        );
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
                                'assets/HinhAnh/MonAn/${monAn['hinh'] ?? 'default_food.png'}',
                              ),
                              onBackgroundImageError: (exception, stackTrace) {
                                debugPrint(
                                  'Lỗi tải ảnh món ăn: ${monAn['hinh'] ?? 'default_food.png'}, Lỗi: $exception',
                                );
                              },
                            ),
                            title: Text(
                              monAn['ten_mon'] ?? 'Chưa có tên',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Loại: ${loaiMonAn['ten_loai']}\nGiá: ${monAn['don_gia']?.toStringAsFixed(2) ?? 'N/A'} VNĐ',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.add_shopping_cart,
                                    color: Color(0xFFE91E63),
                                  ),
                                  onPressed: () {
                                    Provider.of<CartController>(
                                      context,
                                      listen: false,
                                    ).addItem(
                                      MonAn.fromMap(monAn),
                                    ); // monAn là Map, cần fromMap
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Đã thêm vào giỏ hàng.'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed:
                                      () => _showAddEditDialog(monAn: monAn),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await _deleteMonAn(
                                      monAn['ma_mon'],
                                    ); // Sửa thành ma_mon
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
