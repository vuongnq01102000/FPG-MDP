# FPG-MDP ( Flutter Project Generator with Multiple Design Patterns)
(Tạo dự án Flutter với cấu trúc Design Pattern)

## Giới thiệu

Đây là một công cụ dòng lệnh để tạo dự án Flutter với khả năng lựa chọn giữa các mẫu thiết kế khác nhau: Clean Architecture, MVVM, và MVC. Công cụ này tự động tạo một dự án Flutter mới và thiết lập cấu trúc dự án theo mẫu thiết kế bạn chọn.

## Yêu cầu

- Flutter SDK
- Dart
- Bash shell

## Cài đặt

1. Clone repository này về máy của bạn:
`git clone https://github.com/vuongnq01102000/FPG-MDP`
2. Di chuyển vào thư mục chứa script:
`cd [tên_thư_mục]`
3. Cấp quyền thực thi cho script:
`chmod +x tool_create_project.sh`

## Sử dụng

1. Chạy script bằng lệnh: `./tool_create_project.sh`
2. Làm theo các hướng dẫn trên màn hình:
- Nhập đường dẫn để lưu dự án (mặc định là thư mục hiện tại)
- Nhập tên dự án (mặc định là "example_project")
- Chọn mẫu thiết kế: Clean Architecture, MVVM, hoặc MVC

3. Script sẽ tự động tạo dự án Flutter với cấu trúc phù hợp với mẫu thiết kế bạn đã chọn.

## Cấu trúc dự án

Tùy thuộc vào mẫu thiết kế bạn chọn, cấu trúc dự án sẽ khác nhau:

### Clean Architecture
```
project_name/
├── lib/
│   └── main.dart
├── packages/
│   ├── app/ (code UI và state management ở trong module này, có thể định nghĩa các static UI như Colors, Dimens, TextStyle, ...etc )
│   ├── data/ (Chứa các data model class, mapper, converter, source base (RestApiClient, GraphQlApiClient, 
│       đồng thời cũng là nơi cung cấp data source trong project như AppApiService, AppDatabase, AppSharedPreferences, LocationDataSource,…etc))
│   ├── domain/ (Chứa navigation, entity, repository, usecase, ...etc)
│   ├── initializer/ (Cung cấp AppInitializer để config tất cả các module khác vào chung 1 hàm)
│   ├── resources/ (Chứa các file .arb cung cấp các String để làm localization)
│   └── shared/ (Cung cấp các constants, các class custom exception, các class helper, mixin và các hàm utils)
├── pubspec.yaml
└── [Các file và thư mục khác của dự án Flutter]
```

### MVVM
```
project_name/
├── lib/
│   └── main.dart
├── packages/
│   ├── models/ 
│   ├── views/
│   └── view_models/
├── pubspec.yaml
└── [Các file và thư mục khác của dự án Flutter]
```
### MVC
```
project_name/
├── lib/
│   └── main.dart
├── packages/
│   ├── models/
│   ├── views/
│   └── controllers/
├── pubspec.yaml
└── [Các file và thư mục khác của dự án Flutter]
```

## Xử lý sự cố

Nếu bạn gặp lỗi liên quan đến quyền truy cập thư mục cache, hãy thử chạy lệnh sau: `sudo chown -R $(whoami) ~/.pub-cache`

## Đóng góp

Mọi đóng góp đều được hoan nghênh! Hãy tạo issue hoặc pull request nếu bạn muốn cải thiện công cụ này.
