import 'dart:io';

import 'package:tool_create_prj_clean_architecture/config/tool_create_base_app_config.dart';
import 'package:tool_create_prj_clean_architecture/network/tool_create_base_network_client.dart';

class CleanArchitecture {
  final ToolCreateBaseNetworkClient _baseNetworkClient =
      ToolCreateBaseNetworkClient();

  final ToolCreateBaseAppConfig _baseAppConfig = ToolCreateBaseAppConfig();
  void createProject(
      {required String projectPath,
      required String projectName,
      required int styleDesignPattern}) {
    // Tạo thư mục gốc của dự án.
    final fullPath = '$projectPath/$projectName';
    // Tạo dự án Flutter cơ bản
    print('Creating Flutter project...');
    var result = Process.runSync('flutter', ['create', fullPath]);

    if (result.exitCode != 0) {
      print('Error creating Flutter project: ${result.stderr}');
      return;
    }
    print('Flutter project created successfully.');

    final projectDir = Directory(fullPath);

    // Đảm bảo rằng thư mục dự án đã được tạo
    if (!projectDir.existsSync()) {
      print('Error: Project directory was not created.');
      return;
    }

    // Tạo thư mục packages
    final packagesDir = Directory('${projectDir.path}/packages');
    packagesDir.createSync();

    // Tạo các module (packages)
    final modules = createModuleNameWithStyleDesignPattern(styleDesignPattern);

    //  [
    //   'app',
    //   'data',
    //   'domain',
    //   'initializer',
    //   'resources',
    //   'shared'
    // ];

    for (final module in modules) {
      final moduleDir = Directory('${packagesDir.path}/$module');
      moduleDir.createSync(recursive: true);

      createModuleStructure(moduleDir.path, module);

      // Tạo các file cần thiết cho từng module
      switch (module) {
        case 'domain':
          _baseNetworkClient.createBaseNetworkClass(moduleDir.path);
          break;
        case 'shared':
          _baseAppConfig.createAppConfig(moduleDir.path);
          break;
      }
    }
    // Cập nhật .gitignore để không theo dõi file .env
    final gitignoreFile = File('${projectDir.path}/.gitignore');
    gitignoreFile.writeAsStringSync('\n.env', mode: FileMode.append);

    // Cập nhật pubspec.yaml của dự án chính
    updateMainPubspec(projectDir.path, modules);

    // Cập nhật main.dart
    updateMainDart(projectDir.path);

    print('Đã tạo dự án $projectName với cấu trúc Clean Architecture.\n'
        'Hãy chạy "flutter pub get" để cài đặt các dependencies.');
  }

  // Tạo file pubspec.yaml với nội dung tùy chỉnh cho từng module

  void createModuleStructure(String path, String moduleName) {
    // Tạo thư mục lib
    // final libDir = Directory('$path/lib');
    // libDir.createSync();
    var result = Process.runSync(
      'flutter',
      ['create', '--template=package', '.'],
      workingDirectory: path,
    );

    if (result.exitCode != 0) {
      print('Error creating Flutter package: ${result.stderr}');
      return;
    }

    // Tạo file pubspec.yaml
    String pubspecContent = '''
name: $moduleName
description: A new Flutter package for $moduleName module.
version: 0.0.1
publish_to: 'none'

environment:
  sdk: ">=3.4.3 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
''';

    switch (moduleName) {
      case "domain":
        pubspecContent += '''
  dio: ^5.5.0+1
''';
        break;
      case "app":
        pubspecContent += '''
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5
''';
        break;
      case "data":
        pubspecContent += '''
  json_annotation: ^4.9.0
''';
        break;
      case 'shared':
        pubspecContent += '''
  flutter_dotenv: ^5.1.0
''';
      default:
        break;
    }

    pubspecContent += '''
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
''';

    File('$path/pubspec.yaml').writeAsStringSync(pubspecContent);

    // Tạo file README.md
    File('$path/README.md').writeAsStringSync(
        '# $moduleName\n\nA Flutter package for $moduleName module.');

    // Tạo file .gitignore
    File('$path/.gitignore').writeAsStringSync('''
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
migrate_working_dir/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# Flutter/Dart/Pub related
**/doc/api/
**/ios/Flutter/.last_build_id
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
/build/

# Web related
lib/generated_plugin_registrant.dart
''');
  }

  // Đang bị lỗi duplicate dependencies khi chạy lệnh flutter pub get vì khi flutter create ngoài prj chính thì nó đã có file pubspec.yaml rồi nên khi updateMainPubspec nó sẽ thêm dependencies vào file pubspec.yaml của module và file pubspec.yaml của dự án chính, nhớ chỉnh sửa lại hàm updateMainPubspec như sau:
  // Cập nhật file pubspec.yaml của các module vào file pubspec.yaml của dự án chính
  // xem lại chỗ này khi mở project lên hôm nay ngày 26/07/2024

  // Cập nhật file pubspec.yaml của các module vào file pubspec.yaml của dự án chính
  void updateMainPubspec(String projectPath, List<String> modules) {
    final pubspecFile = File('$projectPath/pubspec.yaml');
    var content = pubspecFile.readAsStringSync();

    // Tìm vị trí của 'dependencies:'
    final dependenciesIndex = content.indexOf('dependencies:');
    if (dependenciesIndex == -1) {
      // Nếu không tìm thấy 'dependencies:', thì thêm vào cuối file
      // Thêm các module làm dependencies
      content += '\n\ndependencies:';
      for (final module in modules) {
        content += '\n  $module:\n    path: packages/$module';
      }
      return;
    }

    // Tìm vị trí để chèn các module mới
    var insertIndex = content.indexOf('\n', dependenciesIndex);
    if (insertIndex == -1) {
      insertIndex = content.length;
    }

    // Tạo chuỗi chứa các module mới
    var newDependencies = '';
    for (final module in modules) {
      newDependencies += '  $module:\n    path: packages/$module\n';
    }

    // Chèn các module mới vào nội dung
    content =
        '${content.substring(0, insertIndex)}\n$newDependencies${content.substring(insertIndex)}';

    // Ghi nội dung mới vào file
    pubspecFile.writeAsStringSync(content);

    // content += '\n\ndev_dependencies:';
    // content += '\n    lints:\n      ^3.0.0';
  }

  // Cập nhật file main.dart
  void updateMainDart(String projectPath) {
    final mainFile = File('$projectPath/lib/main.dart');
    mainFile.writeAsStringSync('''
    import 'package:flutter/material.dart';
    import 'package:flutter_dotenv/flutter_dotenv.dart';
    import 'package:app/app.dart';

    Future<void> main() async {
      await dotenv.load(fileName: ".env");
      runApp(const MyApp());
    }
    ''');
  }

  // Tạo tên module dựa trên design pattern được chọn
  List<String> createModuleNameWithStyleDesignPattern(int styleDesignPattern) {
    switch (styleDesignPattern) {
      case 1:
        print('You choose Clean Architecture design pattern');
        return ['app', 'data', 'domain', 'initializer', 'resources', 'shared'];
      case 2:
        print('You choose MVVM design pattern');
        return ['models', 'views', 'view_models'];

      case 3:
        print('You choose MVC design pattern');
        return ['controllers', 'models', 'views'];

      default:
        print('MVC is default design pattern');
        return ['controllers', 'models', 'views'];
    }
  }
}
