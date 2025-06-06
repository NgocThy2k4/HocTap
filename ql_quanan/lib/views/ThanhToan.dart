// views/ThanhToan.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/CartController.dart'; // Import CartController

class ThanhToan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VNĐ',
    );

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
            Expanded(
              child: ListView.builder(
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
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Logic xử lý thanh toán thực tế (gửi đơn hàng, lưu DB,...)
                  // Sau khi thanh toán thành công, có thể xóa giỏ hàng và hiển thị thông báo
                  cartController.clearCart();
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Thanh toán thành công!'),
                          content: Text('Đơn hàng của bạn đã được tiếp nhận.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng dialog
                                Navigator.of(context).popUntil(
                                  (route) => route.isFirst,
                                ); // Quay về trang chính
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                  );
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
    );
  }
}
