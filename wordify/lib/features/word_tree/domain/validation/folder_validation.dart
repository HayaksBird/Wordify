import 'package:wordify/core/domain/entities/folder.dart';

///
class FolderValidation {
  static const List<String> exceptionCharacters = ['/', '\\'];

  ///
  String? validateName(String newName, List<FolderContent> parentsChildren, [String? oldName]) {

    if (newName.isEmpty) {
      return 'Provide a name';
    } else if (parentsChildren.any((sibling) => sibling.name == newName) && (oldName == null || oldName != newName)) {
      return 'Folder path must be unique';
    } else if (exceptionCharacters.any((char) => newName.contains(char))) {
      return 'Cannot use the following characters: ${exceptionCharacters.join(', ')}';
    }
    
    return null;
  }


  ///
  String? validateChooseFolder(FolderContent? folder) {
    if (folder == null) {
      return "Choose a folder";
    } else { return null; }
  }
}