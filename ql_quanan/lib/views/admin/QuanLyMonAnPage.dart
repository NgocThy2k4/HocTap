// views/admin/QuanLyMonAnPage.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/DatabaseHelper.dart';
import '../../models/MonAn.dart';
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
  List<Map<String, dynamic>> _loaiMonAnList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterMonAn);
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _monAnList = await _dbHelper.getAllMonAn();
    _filteredMonAnList = _monAnList;
    _loaiMonAnList = await _dbHelper.getAllLoaiMonAn();
    setState(() => _isLoading = false);
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
    final TextEditingController tenController = TextEditingController(
      text: monAn?['ten_mon'],
    );
    final TextEditingController donGiaController = TextEditingController(
      text: monAn?['don_gia'].toString(),
    );
    String? selectedLoaiMonAn = monAn?['ma_loai'];
    final TextEditingController hinhController = TextEditingController(
      text: monAn?['hinh'],
    );

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              monAn == null ? 'Thêm Món Ăn' : 'Sửa Món Ăn',
              style: TextStyle(color: Color(0xFFE91E63)),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                                value: loai['ma_loai'],
                                child: Text(loai['ten_loai']),
                              ),
                            )
                            .toList(),
                    onChanged: (value) => selectedLoaiMonAn = value,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: hinhController,
                    decoration: InputDecoration(
                      labelText: 'Tên file hình ảnh',
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

                  final newMonAn = {
                    'ma_mon_an':
                        monAn?['ma_mon_an'] ??
                        'MA${DateTime.now().millisecondsSinceEpoch}',
                    'ten_mon': tenController.text,
                    'don_gia': double.parse(donGiaController.text),
                    'ma_loai': selectedLoaiMonAn,
                    'hinh': hinhController.text,
                  };

                  if (monAn == null) {
                    await _dbHelper.insertMonAn(newMonAn);
                  } else {
                    await _dbHelper.updateMonAn(newMonAn);
                  }

                  _loadData();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        monAn == null
                            ? 'Thêm món ăn thành công.'
                            : 'Cập nhật món ăn thành công.',
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
                            ),
                            title: Text(
                              monAn['ten_mon'] ?? 'Chưa có tên',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Loại: ${loaiMonAn['ten_loai']}\nGiá: ${monAn['don_gia'].toStringAsFixed(2)} VNĐ',
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
                                    ).addItem(MonAn.fromMap(monAn));
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
                                              'Bạn có chắc muốn xóa món ăn này?',
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
                                      await _dbHelper.deleteMonAn(
                                        monAn['ma_mon_an'],
                                      );
                                      _loadData();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Đã xóa món ăn.'),
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
