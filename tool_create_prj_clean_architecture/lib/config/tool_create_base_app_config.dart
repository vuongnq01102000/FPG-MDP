import 'dart:io';

class ToolCreateBaseAppConfig {
  static final ToolCreateBaseAppConfig _instance =
      ToolCreateBaseAppConfig._internal();

  factory ToolCreateBaseAppConfig() {
    return _instance;
  }

  ToolCreateBaseAppConfig._internal();

  // Create base network client

  void createAppConfig(String sharedPath) {
    final configDir = Directory('$sharedPath/lib/config');
    configDir.createSync(recursive: true);

    final appConfigFile = File('$sharedPath/lib/config/app_config.dart');
    appConfigFile.writeAsStringSync('''
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://default-api.com';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  
  // Thêm các cấu hình khác tại đây
}
''');

    // Tạo file .env trong thư mục gốc của dự án
    final envFile = File('${sharedPath.split('packages/shared').first}.env');
    envFile.writeAsStringSync('''
BASE_URL=https://api.example.com
API_KEY=your_api_key_here
''');
  }
}
