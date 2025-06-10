// views/QuanLyThucDon.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/AuthController.dart';
import '../controllers/MonAnController.dart';
import '../models/MonAn.dart';

class QuanLyThucDon extends StatefulWidget {
  @override
  _QuanLyThucDonState createState() => _QuanLyThucDonState();
}

class _QuanLyThucDonState extends State<QuanLyThucDon> {
  final _formKey = GlobalKey<FormState>();
  final _tenMonController = TextEditingController();
  final _donGiaController = TextEditingController();
  final _hinhController = TextEditingController();
  final MonAnController _monAnController = MonAnController();

  @override
  void dispose() {
    _tenMonController.dispose();
    _donGiaController.dispose();
    _hinhController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUser = authController.currentUser;

    if (currentUser == null || currentUser.maVaiTro != 'QL') {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Quản Lý Thực Đơn',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFFFFB2D9),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Text(
            'Chỉ quản lý mới có thể quản lý thực đơn.',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản Lý Thực Đơn',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddMonAnDialog(context);
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFFCE4EC),
      body: FutureBuilder<List<MonAn>>(
        future: _monAnController.fetchAllMonAn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final monAnList = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: monAnList.length,
            itemBuilder: (context, index) {
              final monAn = monAnList[index];
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: Image.asset(
                    'assets/HinhAnh/MonAn/${monAn.hinh}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Icon(Icons.error),
                  ),
                  title: Text(monAn.tenMon),
                  subtitle: Text('Giá: ${monAn.donGia} VNĐ'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _tenMonController.text = monAn.tenMon;
                          _donGiaController.text = monAn.donGia.toString();
                          _hinhController.text = monAn.hinh ?? '';
                          _showEditMonAnDialog(context, monAn);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteMonAnDialog(context, monAn);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddMonAnDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Thêm Món Ăn'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _tenMonController,
                  decoration: InputDecoration(labelText: 'Tên món ăn'),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Vui lòng nhập tên món ăn' : null,
                ),
                TextFormField(
                  controller: _donGiaController,
                  decoration: InputDecoration(labelText: 'Đơn giá'),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Vui lòng nhập đơn giá' : null,
                ),
                TextFormField(
                  controller: _hinhController,
                  decoration: InputDecoration(labelText: 'Tên file hình ảnh'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Thêm'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final newMonAn = MonAn(
                    maMon: 'MA${DateTime.now().millisecondsSinceEpoch}',
                    maLoai: 'LOAI1',
                    tenMon: _tenMonController.text,
                    donGia: double.parse(_donGiaController.text),
                    hinh:
                        _hinhController.text.isEmpty
                            ? null
                            : _hinhController.text,
                  );
                  await _monAnController.addMonAn(newMonAn);
                  Navigator.of(dialogContext).pop();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thêm món ăn thành công!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditMonAnDialog(BuildContext context, MonAn monAn) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Sửa Món Ăn'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _tenMonController,
                  decoration: InputDecoration(labelText: 'Tên món ăn'),
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Vui lòng nhập tên món ăn' : null,
                ),
                TextFormField(
                  controller: _donGiaController,
                  decoration: InputDecoration(labelText: 'Đơn giá'),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value!.isEmpty ? 'Vui lòng nhập đơn giá' : null,
                ),
                TextFormField(
                  controller: _hinhController,
                  decoration: InputDecoration(labelText: 'Tên file hình ảnh'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final updatedMonAn = MonAn(
                    maMon: monAn.maMon,
                    maLoai: monAn.maLoai,
                    tenMon: _tenMonController.text,
                    donGia: double.parse(_donGiaController.text),
                    hinh:
                        _hinhController.text.isEmpty
                            ? null
                            : _hinhController.text,
                  );
                  await _monAnController.updateCurrentMonAn(updatedMonAn);
                  Navigator.of(dialogContext).pop();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cập nhật món ăn thành công!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteMonAnDialog(BuildContext context, MonAn monAn) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Xóa Món Ăn'),
          content: Text(
            'Bạn có chắc muốn xóa "${monAn.tenMon}" khỏi thực đơn?',
          ),
          actions: [
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Xóa', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await _monAnController.deleteMonAn(monAn.maMon);
                Navigator.of(dialogContext).pop();
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Xóa món ăn thành công!'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
