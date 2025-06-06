// views/DanhSachMonAn.dart (Cập nhật)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../controllers/MonAnController.dart';
import '../controllers/CartController.dart'; // Import CartController
import '../models/MonAn.dart';
import 'ChiTietMonAn.dart';
import 'GioHang.dart';

class TrangDanhSachMonAn extends StatefulWidget {
  @override
  _TrangDanhSachMonAnState createState() => _TrangDanhSachMonAnState();
}

class _TrangDanhSachMonAnState extends State<TrangDanhSachMonAn> {
  final MonAnController _monAnController = MonAnController();
  List<MonAn> danhSachMonAn = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMonAn();
  }

  _loadMonAn() async {
    setState(() {
      isLoading = true;
    });
    danhSachMonAn = await _monAnController.fetchAllMonAn();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy CartController từ Provider
    final cartController = Provider.of<CartController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Món Ăn', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GioHang()),
                  );
                },
              ),
              // Hiển thị số lượng món trong giỏ hàng
              Positioned(
                right: 5,
                top: 5,
                child: Consumer<CartController>(
                  builder: (context, cart, child) {
                    return Visibility(
                      visible:
                          cart.totalItems >
                          0, // Chỉ hiển thị nếu có món trong giỏ
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cart.totalItems}',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Color(0xFFFCE4EC),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFB2D9)),
                ),
              )
              : GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: danhSachMonAn.length,
                itemBuilder: (context, index) {
                  return MonAnCard(
                    monAn: danhSachMonAn[index],
                    onAddToCart: (MonAn monAn) {
                      cartController.addItem(monAn);
                      _showSnackBar(context);
                    },
                  );
                },
              ),
    );
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Đã thêm vào giỏ hàng thành công!',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFFFF4081),
      ),
    );
  }
}

class MonAnCard extends StatelessWidget {
  final MonAn monAn;
  final Function(MonAn) onAddToCart; // Thêm callback để thêm vào giỏ hàng

  MonAnCard({required this.monAn, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
    );

    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChiTietMonAn(maMon: monAn.maMon),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/HinhAnh/MonAn/${monAn.hinh}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (
                      BuildContext context,
                      Object exception,
                      StackTrace? stackTrace,
                    ) {
                      return Center(child: Text('Không có hình ảnh'));
                    },
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                monAn.tenMon,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE91E63),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (monAn.donGiaKhuyenMai != null && monAn.donGiaKhuyenMai! > 0)
                Row(
                  children: [
                    Text(
                      currencyFormat.format(monAn.donGiaKhuyenMai),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      currencyFormat.format(monAn.donGia),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  currencyFormat.format(monAn.donGia),
                  style: TextStyle(fontSize: 14),
                ),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    onAddToCart(monAn); // Gọi callback khi ấn nút
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFB2D9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.add, color: Colors.white),
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
