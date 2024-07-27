#!/bin/bash

# Hàm để tạo tên dự án nếu tên mặc định đã tồn tại
generate_project_name() {
  base_name=$1
  project_path=$2
  counter=1
  project_name="${base_name}_${counter}"
  while [ -d "${project_path}/${project_name}" ]; do
    counter=$((counter + 1))
    project_name="${base_name}_${counter}"
  done
  echo "$project_name"
}

create_project() {
  while true; do
    echo "================== Create Flutter Project With Design Pattern =================="
    read -p "Please input location to save project (default is current directory, type 'exit' to quit): " project_path

    # Thoát nếu người dùng nhập 'exit'
    if [ "$project_path" == "exit" ]; then
      echo "Exiting script."
      exit 0
    fi

    # Nếu không nhập, sử dụng thư mục hiện tại, pwd là lấy đường dẫn thư mục root hiện tại của máy
    if [ -z "$project_path" ]; then
      project_path=$(pwd)
    fi

    # Kiểm tra xem thư mục có tồn tại không
    if [ ! -d "$project_path" ]; then
      echo "The specified path does not exist. Please try again."
      continue
    fi

    # Kiểm tra quyền ghi
    if [ ! -w "$project_path" ]; then
      echo "You don't have write permission to the specified path. Please try again."
      continue
    fi

    echo "Project will be saved in: $project_path"

    while true; do
      read -p "Please input project name (default is example_project, type 'back' to re-enter project path, type 'exit' to quit): " project_name

      # Thoát nếu người dùng nhập 'exit'
      if [ "$project_name" == "exit" ]; then
        echo "Exiting script."
        exit 0
      fi

      # Nếu người dùng nhập 'back', quay lại nhập đường dẫn
      if [ "$project_name" == "back" ]; then
        break
      fi

      # Nếu không nhập, sử dụng tên mặc định
      if [ -z "$project_name" ]; then
        project_name="example_project"
        project_name=$(generate_project_name "$project_name" "$project_path")
      fi

      echo "Project name will be: $project_name"


    while true; do

      echo 'Please choose style design pattern (default is Clean Architecture) '
      echo '1. Clean Architecture'
      echo '2. MVVM'
      echo '3. MVC'
      echo '4. Back'
      echo '5. Exit'
      read -p "Enter your style design pattern: " style_pattern

      # Thoát nếu người dùng nhập '4'
      if [ "$style_pattern" == "5" ]; then
        echo "Exiting script."
        exit 0
      fi

      # Nếu người dùng nhập '4', quay lại nhập đường dẫn
      if [ "$style_pattern" == "4" ]; then
        break
      fi

      # Nếu không nhập, sử dụng kiến trúc mặc định
      if [ -z "$style_pattern" ]; then
        style_pattern="1"
       
      fi

      design_pattern_name=$(generate_design_pattern_name "$style_pattern")
      echo "Project design pattern will be a: $design_pattern_name"

      # Điều hướng đến thư mục chứa dự án
      cd "$project_path" || exit

    #  Chạy script Dart để tạo dự án
      if dart run ~/Devloper/tool_create_prj_clean_architecture/bin/tool_create_prj_clean_architecture.dart "$project_path" "$project_name" "$style_pattern"; then
          echo "Project $project_name with $design_pattern_name  has been created at $project_path"
        return
      else
        echo "Failed to create project. Please check the Dart script and try again."
      fi
  
       return

    done
  done
done
}

# Hàm để tạo tên mẫu thiết kế dựa trên lựa chọn của người dùng
generate_design_pattern_name() {
  style_pattern=$1

  case "$style_pattern" in
    1)
      design_pattern_name="Clean Architecture"
      ;;
    2)
      design_pattern_name="MVVM"
      ;;
    3)
      design_pattern_name="MVC"
      ;;
    4)
      echo "Going back to previous menu..."
      return 1
      ;;
    5)
      echo "Exiting..."
      exit 0
      ;;
    *)
      design_pattern_name="Clean Architecture"
      ;;
  esac
  echo "$design_pattern_name"
}


check_and_fix_permissions() {
    local cache_dir="$HOME/.pub-cache"
    if [ ! -w "$cache_dir" ]; then
        echo "Fixing permissions for Flutter cache directory..."
        sudo chown -R $(whoami) "$cache_dir"
    fi
}

# Bên dưới này là lên script cho chạy lệnh nào trước

# Kiểm tra quyền truy cập thư mục cache trước
check_and_fix_permissions

# Sau đó mới tiến hành create project
create_project