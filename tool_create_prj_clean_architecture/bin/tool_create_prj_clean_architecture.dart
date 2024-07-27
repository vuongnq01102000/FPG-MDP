import 'dart:io';

import 'package:tool_create_prj_clean_architecture/tool_create_prj_clean_architecture.dart'
    as tool_create_prj_clean_architecture;

void main(List<String> arguments) {
  if (arguments.length < 3) {
    stdout
        .write('Please provide project path, project name and design pattern');
    return;
  }

  final projectPath = arguments[0];
  final projectName = arguments[1];
  final designPattern = arguments[2];
  tool_create_prj_clean_architecture.CleanArchitecture cleanArchitecture =
      tool_create_prj_clean_architecture.CleanArchitecture();

  cleanArchitecture.createProject(
    projectPath: projectPath,
    projectName: projectName,
    styleDesignPattern: int.tryParse(designPattern) ?? 1,
  );
}
