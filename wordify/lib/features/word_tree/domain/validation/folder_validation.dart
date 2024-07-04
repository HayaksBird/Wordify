import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/use_cases/dictionary_manager.dart';

///
class FolderValidation {
  final DictionaryStateManager _dictionaryStateManager = DictionaryStateManager();
  ///
  String? validateName({required String name, String? oldName}) {

    if (name.isEmpty) {
      return 'Provide a name';
    } else if (/*_dictionaryManager.isFolderInView(name) && */(oldName == null || oldName != name)) {
      return 'Folder name must be unique';
    } else {
      return null;
    }
  }


  ///
  String? validateChooseFolder(Folder? folder) {
    if (folder == null) {
      return "Choose a folder";
    } else { return null; }
  }
}