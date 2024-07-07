import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///
class FolderValidation {

  ///
  String? validateName(String newName, List<Folder> parentsChildren, [String? oldName]) {

    if (newName.isEmpty) {
      return 'Provide a name';
    } else if (parentsChildren.any((sibling) => sibling.name == newName) && (oldName == null || oldName != newName)) {
      return 'Folder name must be unique';
    }
    
    return null;
  }


  ///
  String? validateChooseFolder(Folder? folder) {
    if (folder == null) {
      return "Choose a folder";
    } else { return null; }
  }
}