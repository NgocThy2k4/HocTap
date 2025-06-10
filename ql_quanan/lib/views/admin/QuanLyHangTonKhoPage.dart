// views/admin/QuanLyHangTonKhoPage.dart
import 'package:flutter/material.dart';
import '../../database/DatabaseHelper.dart';

class QuanLyHangTonKhoPage extends StatefulWidget {
  @override
  _QuanLyHangTonKhoPageState createState() => _QuanLyHangTonKhoPageState();
}

class _QuanLyHangTonKhoPageState extends State<QuanLyHangTonKhoPage> {
  final QLQuanAnDatabaseHelper _dbHelper = QLQuanAnDatabaseHelper.instance;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _inventoryList = [];
  List<Map<String, dynamic>> _filteredInventoryList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInventory();
    _searchController.addListener(_filterInventory);
  }

  Future<void> _loadInventory() async {
    setState(() => _isLoading = true);
    _inventoryList = await _dbHelper.getAllInventory();
    _filteredInventoryList = _inventoryList;
    setState(() => _isLoading = false);
  }

  void _filterInventory() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredInventoryList =
          _inventoryList.where((item) {
            final tenNguyenLieu =
                item['ten_nguyen_lieu'].toString().toLowerCase();
            return tenNguyenLieu.contains(query);
          }).toList();
    });
  }

  Future<void> _showAddEditDialog({Map<String, dynamic>? item}) async {
    final TextEditingController tenController = TextEditingController(
      text: item?['ten_nguyen_lieu'],
    );
    final TextEditingController soLuongController = TextEditingController(
      text: item?['so_luong_ton'].toString(),
    );
    final TextEditingController donViController = TextEditingController(
      text: item?['don_vi'],
    );
    final TextEditingController nguongController = TextEditingController(
      text: item?['nguong_canh_bao'].toString(),
    );
    final TextEditingController ghiChuController = TextEditingController(
      text: item?['ghi_chu'],
    );

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              item == null ? 'Thêm Nguyên Liệu' : 'Sửa Nguyên Liệu',
              style: TextStyle(color: Color(0xFFE91E63)),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tenController,
                    decoration: InputDecoration(
                      labelText: 'Tên nguyên liệu',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: soLuongController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Số lượng tồn',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: donViController,
                    decoration: InputDecoration(
                      labelText: 'Đơn vị (kg, lít, ...)',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: nguongController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Ngưỡng cảnh báo',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: ghiChuController,
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
              TextButton(
                onPressed: () async {
                  if (tenController.text.isEmpty ||
                      soLuongController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Vui lòng nhập đầy đủ thông tin.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final newItem = {
                    'ma_nguyen_lieu':
                        item?['ma_nguyen_lieu'] ??
                        await _dbHelper.generateInventoryId(),
                    'ten_nguyen_lieu': tenController.text,
                    'so_luong_ton': int.parse(soLuongController.text),
                    'don_vi': donViController.text,
                    'nguong_canh_bao':
                        nguongController.text.isEmpty
                            ? null
                            : int.parse(nguongController.text),
                    'ghi_chu': ghiChuController.text,
                  };

                  if (item == null) {
                    await _dbHelper.insertInventory(newItem);
                  } else {
                    await _dbHelper.updateInventory(newItem);
                  }

                  _loadInventory();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        item == null
                            ? 'Thêm nguyên liệu thành công.'
                            : 'Cập nhật nguyên liệu thành công.',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text('Lưu', style: TextStyle(color: Color(0xFFE91E63))),
              ),
            ],
          ),
    );
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
          'Quản Lý Hàng Tồn Kho',
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
                hintText: 'Tìm kiếm nguyên liệu...',
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
                    : _filteredInventoryList.isEmpty
                    ? Center(child: Text('Không có nguyên liệu nào.'))
                    : ListView.builder(
                      itemCount: _filteredInventoryList.length,
                      itemBuilder: (context, index) {
                        final item = _filteredInventoryList[index];
                        final isLowStock =
                            item['nguong_canh_bao'] != null &&
                            item['so_luong_ton'] <= item['nguong_canh_bao'];
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
                            title: Text(
                              item['ten_nguyen_lieu'] ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Số lượng: ${item['so_luong_ton']} ${item['don_vi'] ?? ''}\n'
                              'Ngưỡng cảnh báo: ${item['nguong_canh_bao'] ?? 'Không đặt'}',
                              style: TextStyle(
                                color: isLowStock ? Colors.red : Colors.black87,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed:
                                      () => _showAddEditDialog(item: item),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text(
                                              'Xác nhận xóa',
                                              style: TextStyle(
                                                color: Color(0xFFE91E63),
                                              ),
                                            ),
                                            content: Text(
                                              'Bạn có chắc muốn xóa nguyên liệu này?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      false,
                                                    ),
                                                child: Text(
                                                  'Hủy',
                                                  style: TextStyle(
                                                    color: Color(0xFFE91E63),
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      true,
                                                    ),
                                                child: Text(
                                                  'Xóa',
                                                  style: TextStyle(
                                                    color: Color(0xFFE91E63),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    );
                                    if (confirm == true) {
                                      await _dbHelper.deleteInventory(
                                        item['ma_nguyen_lieu'],
                                      );
                                      _loadInventory();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Đã xóa nguyên liệu.'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
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
