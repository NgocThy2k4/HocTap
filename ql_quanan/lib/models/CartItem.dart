// models/CartItem.dart

import 'MonAn.dart'; // Import MonAn model

class CartItem {
  final MonAn monAn;
  int quantity;

  CartItem({required this.monAn, this.quantity = 1});

  // Có thể thêm các phương thức tiện ích nếu cần, ví dụ:
  double get totalPrice =>
      (monAn.donGiaKhuyenMai != null && monAn.donGiaKhuyenMai! > 0
          ? monAn.donGiaKhuyenMai!
          : monAn.donGia!) *
      quantity;

  // Chuyển đổi đối tượng CartItem thành Map để lưu vào cơ sở dữ liệu
  Map<String, dynamic> toMap() {
    return {'ma_mon': monAn.maMon, 'quantity': quantity};
  }

  // Tạo CartItem từ Map (ví dụ khi lấy từ cơ sở dữ liệu)
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      monAn: MonAn.fromMap(
        map,
      ), // Giả sử bạn có phương thức fromMap trong MonAn
      quantity: map['quantity'] ?? 1,
    );
  }
}
