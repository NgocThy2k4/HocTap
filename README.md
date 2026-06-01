<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Arial&weight=700&size=36&duration=3000&pause=500&color=FF5722&vCenter=true&center=true&width=700&height=60&lines=%C4%90%E1%BB%92%20%C3%81N%3A%20H%E1%BB%86%20TH%E1%BB%90NG%20QU%E1%BA%A2N%20L%C3%9D%20QU%C3%81N%20%C4%82N;FLUTTER%20FOOD%20MANAGEMENT%20SYSTEM" alt="Typing SVG" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.7.2-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-Ready-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/SQLite-Database-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green?style=for-the-badge" alt="Platform">
</p>

---

## 📱 Giới thiệu ngắn

**Hệ thống Quản Lý Quán Ăn** là một ứng dụng di động đa nền tảng được phát triển hoàn toàn bằng **Flutter & Dart**. Ứng dụng giải quyết bài toán tối ưu quy trình vận hành cho các nhà hàng/quán ăn vừa và nhỏ, mang lại trải nghiệm gọi món mượt mà cho Khách hàng cùng một hệ thống quản trị (Admin) chuyên sâu từ quản lý kho, nhân sự đến phân tích doanh thu theo thời gian thực.

### 👥 Thành viên thực hiện
| Vai trò | Họ và tên | MSSV | Lớp |
| :--- | :--- | :--- | :--- |
| **Sinh viên thực hiện** | [Tên sinh viên] | [Mã số sinh viên] | [Tên lớp] |
| **Giảng viên hướng dẫn** | [Tên giảng viên] | - | [Bộ môn / Khoa] |

---

## ✨ Các tính năng chính

### 🛒 Dành cho Khách Hàng
*   **🏠 Trang chủ thông minh:** Banner trượt slider sống động hiển thị món ăn nổi bật và các chương trình khuyến mại hot.
*   **🍽️ Thực đơn trực quan:** Duyệt danh sách món ăn phân loại theo danh mục, tích hợp tìm kiếm nhanh và xem chi tiết hình ảnh.
*   **🛍️ Giỏ hàng linh hoạt:** Thêm/xóa/sửa số lượng món ăn trực tiếp, tự động áp mã giảm giá và tính tổng tiền chuẩn xác.
*   **💳 Thanh toán & Theo dõi:** Quy trình checkout tối giản, xem lịch sử đơn hàng và cập nhật trạng thái đơn hàng theo thời gian thực.
*   **⭐ Đánh giá & Phản hồi:** Chức năng để lại nhận xét, chấm điểm sao giúp nâng cao chất lượng phục vụ của quán.
*   **🔔 Thông báo cá nhân:** Nhận tin tức, ưu đãi hoặc cảnh báo đơn hàng ngay trên thanh thông báo.

### 📊 Dành cho Admin / Quản lý viên
*   **🍴 Quản trị thực đơn:** Toàn quyền Thêm/Sửa/Xóa món ăn, quản lý danh mục, cập nhật giá bán và trạng thái "Còn hàng/Hết hàng".
*   **📦 Quản lý kho nâng cao:** Theo dõi số lượng nguyên liệu tồn kho, tự động đưa ra cảnh báo khi vật tư chạm ngưỡng tối thiểu.
*   **👥 Điều phối nhân sự:** Thêm mới nhân viên, cập nhật thông tin và phân quyền bảo mật 3 cấp độ chặt chẽ (`Admin` / `Staff` / `Tester`).
*   **🧾 Xử lý đơn hàng:** Tiếp nhận đơn, phân loại điều phối và cập nhật trạng thái vận chuyển cho khách hàng.
*   **📈 Thống kê & Báo cáo:** Trực quan hóa dữ liệu kinh doanh thông qua biểu đồ hình cột/đường sinh động, xuất báo cáo doanh thu theo Ngày / Tháng / Năm.

---

## 🛠️ Công nghệ & Thư viện sử dụng

### 🔹 Core Core & Database
*   **Flutter (v3.7.2)** & **Dart**: Framework và ngôn ngữ lập trình tối ưu hiệu năng native.
*   **SQLite (`sqflite`)**: Cơ sở dữ liệu nội bộ gọn nhẹ, truy vấn dữ liệu quan hệ cục bộ tốc độ cao.

### 🔹 Thư viện chính (Dependencies)
```yaml
dependencies:
  provider: ^6.1.4                     # Quản lý trạng thái hệ thống (State Management)
  http: ^1.1.0                         # Xử lý API và các yêu cầu kết nối mạng
  image_picker: ^1.1.0                 # Upload hình ảnh từ Camera/Thư viện cho món ăn
  fl_chart: ^1.0.0                     # Công cụ vẽ biểu đồ thống kê doanh thu đa dạng
  carousel_slider: ^5.0.0              # Slider trình chiếu món ăn nổi bật tại trang chủ
  intl: ^0.18.1                        # Định dạng đơn vị tiền tệ (VNĐ/£) và thời gian
  fluttertoast: ^8.0.9                 # Hiển thị thông báo nhanh (Toast Message) ngắn gọn
  url_launcher: ^6.3.0                 # Hỗ trợ quay số hotline, mở bản đồ quán ăn nhanh
  path_provider: ^2.1.5                # Truy cập thư mục bộ nhớ thiết bị lưu trữ DB
  flutter_staggered_animations: ^1.0.0 # Tạo hiệu ứng mượt mà khi load danh sách món ăn
