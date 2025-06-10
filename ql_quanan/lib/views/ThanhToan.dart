// views/ThanhToan.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/CartController.dart';
import '../controllers/AuthController.dart';
import '../database/DatabaseHelper.dart';

class ThanhToan extends StatefulWidget {
  @override
  _ThanhToanState createState() => _ThanhToanState();
}

class _ThanhToanState extends State<ThanhToan> {
  final _formKey = GlobalKey<FormState>();
  final _diaChiController = TextEditingController();
  String _phuongThucThanhToan = 'Tiền mặt';

  @override
  void dispose() {
    _diaChiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUser = authController.currentUser;
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VNĐ',
    );

    if (currentUser == null || currentUser.maVaiTro != 'KH') {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Thanh Toán',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFFFFB2D9),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Text(
            'Chỉ khách hàng mới có thể thực hiện thanh toán.',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thanh Toán',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFFFCE4EC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xác nhận đơn hàng',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cartController.items.length,
                itemBuilder: (context, index) {
                  final item = cartController.items[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              'assets/HinhAnh/MonAn/${item.monAn.hinh}',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.monAn.tenMon,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Số lượng: ${item.quantity}'),
                                Text(
                                  'Giá: ${currencyFormat.format(item.totalPrice)}',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng cộng:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currencyFormat.format(cartController.getTotalPrice()),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Thông tin giao hàng',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _diaChiController,
                      decoration: InputDecoration(
                        labelText: 'Địa chỉ giao hàng',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập địa chỉ giao hàng';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _phuongThucThanhToan,
                      decoration: InputDecoration(
                        labelText: 'Phương thức thanh toán',
                      ),
                      items:
                          ['Tiền mặt', 'Thẻ ngân hàng', 'Ví điện tử'].map((
                            String method,
                          ) {
                            return DropdownMenuItem<String>(
                              value: method,
                              child: Text(method),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _phuongThucThanhToan = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final dbHelper = QLQuanAnDatabaseHelper.instance;
                      final maDonHang = await dbHelper.generateOrderId();
                      final order = {
                        'ma_don_hang': maDonHang,
                        'ma_khach_hang': currentUser.maLienQuan,
                        'tong_tien': cartController.getTotalPrice(),
                        'dia_chi_giao_hang': _diaChiController.text,
                        'phuong_thuc_thanh_toan': _phuongThucThanhToan,
                        'trang_thai': 'Chờ xác nhận',
                        'ngay_dat': DateTime.now().toIso8601String(),
                      };
                      await dbHelper.insertOrder(order);

                      for (var item in cartController.items) {
                        await dbHelper.insertOrderDetail({
                          'ma_don_hang': maDonHang,
                          'ma_mon': item.monAn.maMon,
                          'so_luong': item.quantity,
                          'don_gia': item.totalPrice / item.quantity,
                        });
                      }

                      cartController.clearCart();
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Thanh toán thành công!'),
                              content: Text(
                                'Đơn hàng của bạn đã được tiếp nhận.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(
                                      context,
                                    ).popUntil((route) => route.isFirst);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                      );
                    }
                  },
                  child: Text(
                    'Hoàn tất Thanh toán',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
