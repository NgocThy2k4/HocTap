// views/GioHang.dart (CẬP NHẬT)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/CartController.dart';
import '../controllers/AuthController.dart'; // Import AuthController
import '../models/CartItem.dart';
import 'ThanhToan.dart';

class GioHang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VNĐ',
    );

    // Lắng nghe sự thay đổi của CartController
    return Consumer<CartController>(
      builder: (context, cart, child) {
        // Lấy thông tin người dùng hiện tại từ AuthController
        final authController = Provider.of<AuthController>(
          context,
          listen: false,
        );
        final currentUser = authController.currentUser;

        // Giỏ hàng chỉ hiển thị cho khách hàng hoặc hiển thị tất cả nếu là quản lý/nhân viên
        // Logic phức tạp hơn nếu bạn muốn giỏ hàng theo từng khách hàng cụ thể khi quản lý/nhân viên xem
        // Hiện tại, nếu là QL/NV thì sẽ thấy giỏ hàng của app chung, nếu là KH thì thấy giỏ hàng của session KH đó
        final bool isCustomer = currentUser?.maVaiTro == 'KH';

        // Filter giỏ hàng nếu cần theo người dùng, hiện tại CartController đang quản lý giỏ hàng chung
        // Nếu bạn muốn giỏ hàng riêng cho từng KH/NV, CartController cần lưu trữ Map<String, List<CartItem>>
        // hoặc load từ DB theo userId/ma_lien_quan
        // Hiện tại, giỏ hàng là global của session. Logic "khách hàng chỉ hiển thị giỏ hàng của khách hàng đó"
        // ngụ ý CartController cần persist giỏ hàng theo User ID.
        // Để đơn giản, giả sử giỏ hàng là của người đang sử dụng ứng dụng.
        // Nếu bạn muốn giỏ hàng riêng cho từng KH/NV và lưu trữ vào DB,
        // bạn sẽ phải chỉnh sửa CartController đáng kể.
        // Với setup hiện tại, giỏ hàng hoạt động theo session người dùng đang đăng nhập.

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Giỏ Hàng (${cart.totalItems})',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(0xFFFFB2D9),
            iconTheme: IconThemeData(color: Colors.white),
            actions: [
              if (cart.items.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.delete_sweep, color: Colors.white),
                  onPressed: () {
                    _showClearCartConfirmationDialog(context, cart);
                  },
                ),
            ],
          ),
          backgroundColor: Color(0xFFFCE4EC),
          body:
              cart.items.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Giỏ hàng của bạn đang trống!',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                  : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) {
                            final item = cart.items[index];
                            return Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        'assets/HinhAnh/MonAn/${item.monAn.hinh}',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  color: Colors.grey[200],
                                                  child: Center(
                                                    child: Text('No Image'),
                                                  ),
                                                ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.monAn.tenMon,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFE91E63),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            currencyFormat.format(
                                              item.totalPrice,
                                            ),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  if (item.quantity > 1) {
                                                    cart.decreaseQuantity(item);
                                                  } else {
                                                    _showRemoveItemConfirmationDialog(
                                                      context,
                                                      cart,
                                                      item,
                                                    );
                                                  }
                                                },
                                              ),
                                              Text(
                                                '${item.quantity}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.add_circle,
                                                  color: Colors.green,
                                                ),
                                                onPressed: () {
                                                  cart.increaseQuantity(item);
                                                },
                                              ),
                                              Spacer(),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.grey[600],
                                                ),
                                                onPressed: () {
                                                  _showRemoveItemConfirmationDialog(
                                                    context,
                                                    cart,
                                                    item,
                                                  );
                                                },
                                              ),
                                            ],
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
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, -3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tổng tiền:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  currencyFormat.format(cart.getTotalPrice()),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed:
                                    cart.items.isEmpty
                                        ? null
                                        : () {
                                          // TODO: Logic chuyển sang trang thanh toán.
                                          // Có thể cần truyền thông tin người dùng vào trang ThanhToan
                                          // để biết là khách hàng hay nhân viên/quản lý thanh toán.
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ThanhToan(),
                                            ),
                                          );
                                        },
                                icon: Icon(Icons.payment, color: Colors.white),
                                label: Text(
                                  'Thanh Toán Ngay',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFF6790),
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
                    ],
                  ),
        );
      },
    );
  }

  void _showRemoveItemConfirmationDialog(
    BuildContext context,
    CartController cart,
    CartItem item,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc muốn xóa "${item.monAn.tenMon}" khỏi giỏ hàng không?',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Xóa', style: TextStyle(color: Colors.red)),
              onPressed: () {
                cart.removeItem(item);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Đã xóa "${item.monAn.tenMon}" khỏi giỏ hàng.',
                    ),
                    duration: Duration(seconds: 2),
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

  void _showClearCartConfirmationDialog(
    BuildContext context,
    CartController cart,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Xác nhận xóa tất cả'),
          content: Text(
            'Bạn có chắc muốn xóa tất cả món ăn khỏi giỏ hàng không?',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Xóa tất cả', style: TextStyle(color: Colors.red)),
              onPressed: () {
                cart.clearCart();
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã xóa tất cả món ăn khỏi giỏ hàng.'),
                    duration: Duration(seconds: 2),
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
