import 'package:wordify/features/word_tree/domain/entities/dictionary.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/use_cases/folder_service.dart';

class DictionaryManager {
  late Dictionary _dictionary;
  final FolderService _folderService = FolderService();

  
  ///
  Future<List<Folder>> getFolderList() async {
    List<Folder> folders = await _folderService.getAllFolders();
    _dictionary = Dictionary(foldersInView: folders);

    return folders;
  }


  ///If the folder 
  Future<bool> activateFolder(Folder folder) async {
    if (!_dictionary.activeFolders.contains(folder)) {
      if (folder.words.isEmpty) { //If the folder is first clicked
        Folder folderWithWords = await _folderService.getAllWords(folder);
        int index = _dictionary.foldersInView.lastIndexOf(folder);
        
        _dictionary = Dictionary(
          foldersInView: List<Folder>.from(_dictionary.foldersInView)
            ..[index] = folderWithWords,

          activeFolders: List<Folder>.from(_dictionary.activeFolders)
            ..insert(0, folderWithWords),
        );
      } else {  //If it has been clicked before
        _dictionary = Dictionary(
          foldersInView: List<Folder>.from(_dictionary.foldersInView),
          activeFolders: List<Folder>.from(_dictionary.activeFolders)
            ..insert(0, folder)
        );
      }

      return true;
    } else { return false; }
  }


  ///
  Future<bool> deactivateFolder(Folder folder) async {
    if (_dictionary.activeFolders.contains(folder)) {
      _dictionary = Dictionary(
        foldersInView: List<Folder>.from(_dictionary.foldersInView),

        activeFolders: List<Folder>.from(_dictionary.activeFolders)
          ..remove(folder)
      );

      return true;
    } else { return false; }
  }


  ///
  List<Folder> get foldersInView => _dictionary.foldersInView;


  List<Folder> get activeFolders => _dictionary.activeFolders;
}