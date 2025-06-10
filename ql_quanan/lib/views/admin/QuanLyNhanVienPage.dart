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
    _nhanVienList = await _dbHelper.getAllNhanVien();
    _filteredNhanVienList = _nhanVienList;
    setState(() => _isLoading = false);
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

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(nhanVien == null ? 'Thêm Nhân Viên' : 'Sửa Nhân Viên'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tenController,
                    decoration: InputDecoration(labelText: 'Tên nhân viên'),
                  ),
                  TextField(
                    controller: chucVuController,
                    decoration: InputDecoration(labelText: 'Chức vụ'),
                  ),
                  TextField(
                    controller: diaChiController,
                    decoration: InputDecoration(labelText: 'Địa chỉ'),
                  ),
                  TextField(
                    controller: dienThoaiController,
                    decoration: InputDecoration(labelText: 'Số điện thoại'),
                  ),
                  TextField(
                    controller: ghiChuController,
                    decoration: InputDecoration(labelText: 'Ghi chú'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  if (tenController.text.isEmpty ||
                      chucVuController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Vui lòng nhập đầy đủ thông tin.'),
                      ),
                    );
                    return;
                  }

                  final newNhanVien = NhanVien(
                    maNhanVien:
                        nhanVien?.maNhanVien ??
                        'NV${DateTime.now().millisecondsSinceEpoch}',
                    tenNhanVien: tenController.text,
                    chucVu: chucVuController.text,
                    diaChi: diaChiController.text,
                    dienThoai: dienThoaiController.text,
                    hinhAnh: nhanVien?.hinhAnh ?? 'default_han_vien.jpg',
                    ghiChu: ghiChuController.text,
                  );

                  if (nhanVien == null) {
                    await _dbHelper.insertNhanVien(newNhanVien.toMap());
                  } else {
                    await _dbHelper.updateNhanVien(newNhanVien.toMap());
                  }

                  _loadNhanVien();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        nhanVien == null
                            ? 'Thêm nhân viên thành công.'
                            : 'Cập nhật nhân viên thành công.',
                      ),
                    ),
                  );
                },
                child: Text('Lưu'),
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
        title: Text('Quản Lý Nhân Viên', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                    ? Center(child: CircularProgressIndicator())
                    : _filteredNhanVienList.isEmpty
                    ? Center(child: Text('Không có nhân viên nào.'))
                    : ListView.builder(
                      itemCount: _filteredNhanVienList.length,
                      itemBuilder: (context, index) {
                        final nv = _filteredNhanVienList[index];
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/HinhAnh/NhanVien/${nv.hinhAnh ?? 'default_han_vien.jpg'}',
                              ),
                            ),
                            title: Text(nv.tenNhanVien ?? 'Chưa có tên'),
                            subtitle: Text(
                              '${nv.chucVu ?? ''} - ${nv.dienThoai ?? ''}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => _showAddEditDialog(nv),
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text('Xác nhận xóa'),
                                            content: Text(
                                              'Bạn có chắc muốn xóa nhân viên này?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      false,
                                                    ),
                                                child: Text('Hủy'),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      true,
                                                    ),
                                                child: Text('Xóa'),
                                              ),
                                            ],
                                          ),
                                    );
                                    if (confirm == true) {
                                      await _dbHelper.deleteNhanVien(nv.maNhan);
                                      _loadNhanVien();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Đã xóa nhân viên.'),
                                        ),
                                      );
                                    }
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
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFFFB2D9),
      ),
    );
  }
}
