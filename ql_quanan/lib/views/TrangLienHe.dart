// views/TrangLienHe.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Để mở liên kết, thêm dependency này

class TrangLienHe extends StatelessWidget {
  final String _phoneNumber = '0334909123';
  final String _emailAddress = 'ngocthy@gmail.com';
  final String _facebookUrl = 'https://www.facebook.com/ngoc.thy.177803/';
  final String _githubUrl = 'https://github.com/NgocThy2k4/HocTap/';

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liên Hệ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFFFB2D9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFFFCE4EC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/HinhAnh/LienHe.jpg', // Ảnh liên hệ
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Center(child: Text('Không có hình ảnh')),
                      ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Text(
              'Thông Tin Liên Hệ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
            SizedBox(height: 15),
            ListTile(
              leading: Icon(Icons.location_on, color: Color(0xFFFF6790)),
              title: Text(
                'Địa Chỉ: 140 Lê Trọng Tấn',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Color(0xFFFF6790)),
              title: Text(
                'Số Điện Thoại: $_phoneNumber',
                style: TextStyle(fontSize: 16),
              ),
              trailing: IconButton(
                icon: Icon(Icons.call, color: Colors.green),
                onPressed: () => _launchUrl('tel:$_phoneNumber'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.email, color: Color(0xFFFF6790)),
              title: Text(
                'Email: $_emailAddress',
                style: TextStyle(fontSize: 16),
              ),
              trailing: IconButton(
                icon: Icon(Icons.email, color: Colors.blue),
                onPressed: () => _launchUrl('mailto:$_emailAddress'),
              ),
            ),
            SizedBox(height: 25),
            Text(
              'Mẫu Liên Hệ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Tên của bạn',
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: Color(0xFFFFB2D9),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email của bạn',
                prefixIcon: Icon(
                  Icons.alternate_email,
                  color: Color(0xFFFFB2D9),
                ),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Số điện thoại (tùy chọn)',
                prefixIcon: Icon(Icons.phone_android, color: Color(0xFFFFB2D9)),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Tin nhắn/Yêu cầu của bạn',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Icon(Icons.message, color: Color(0xFFFFB2D9)),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Logic gửi tin nhắn (ví dụ: gửi email hoặc lưu vào DB)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Tin nhắn của bạn đã được gửi!',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: Icon(Icons.send),
                label: Text('Gửi Tin Nhắn'),
              ),
            ),
            SizedBox(height: 25),
            Text(
              'Mạng Xã Hội',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.facebook, size: 40, color: Colors.blue[800]),
                  onPressed: () => _launchUrl(_facebookUrl),
                  tooltip: 'Facebook',
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Image.asset(
                    'assets/github_logo.png',
                    height: 40,
                  ), // Cần ảnh GitHub nếu muốn tùy chỉnh
                  onPressed: () => _launchUrl(_githubUrl),
                  tooltip: 'GitHub',
                ),
                SizedBox(width: 20),
                // Bạn có thể thêm icon và liên kết cho YouTube nếu có
                IconButton(
                  icon: Icon(
                    Icons.play_circle_filled,
                    size: 40,
                    color: Colors.red[700],
                  ),
                  onPressed:
                      () => _launchUrl(
                        'https://www.youtube.com/',
                      ), // Thay bằng link YouTube của bạn
                  tooltip: 'YouTube',
                ),
              ],
            ),
            SizedBox(height: 25),
            Text(
              'Giờ Làm Việc',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),
            SizedBox(height: 15),
            ListTile(
              leading: Icon(Icons.access_time, color: Color(0xFFFF6790)),
              title: Text(
                'Mở cửa từ 7:00 AM - 10:00 PM',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
