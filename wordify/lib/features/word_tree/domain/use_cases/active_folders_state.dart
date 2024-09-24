import 'package:wordify/core/domain/entities/folder.dart';
import 'package:wordify/core/domain/entities/word.dart';
import 'package:wordify/core/domain/mapper/folder_mapper.dart';
import 'package:wordify/core/domain/mapper/word_mapper.dart';
import 'package:wordify/core/domain/use_cases/dictionary_manager.dart';
import 'package:wordify/features/word_tree/data/folder_repository.dart';
import 'package:wordify/features/word_tree/data/word_repository.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';
import 'package:wordify/features/word_tree/domain/repositories/folder_repository.dart';
import 'package:wordify/features/word_tree/domain/repositories/word_repository.dart';

///Manages the state of the active folders of the dictionary.
///Handles all the operations that have to do with the state of the
///active folder.
class ActiveFoldersState {
  final _activeFoldersState = DictionaryManager().activeFoldersState;
  final FolderRepository _folderRepo = FolderRepositoryImpl();
  final WordRepository _wordRepo = WordRepositoryImpl();

  FolderWords? _currentInView;  //current active folder
  bool didGoBelow = false;


  ///Activate the folder and shift the view to it (moving above).
  ///
  ///If the folder is not in cache and not in active folder list
  ///then fetch its words from the DB.
  Future<bool> activateFolder(FolderContent folder) async {
    final folderModel = FolderMapper.toFolderModel(folder);
    bool didActivate;

    if (!_activeFoldersState.isFolderInCache(folderModel) && 
        !_activeFoldersState.isFolderActive(folderModel)) {
      List<WordContent> words = await _wordRepo.getWordsOfFolder(folder);

      didActivate = _activeFoldersState.activateFolder(
        folderModel,
        words.map((word) => WordMapper.toWordModel(word)).toList()
      );
    } else {
      didActivate = _activeFoldersState.activateFolder(folderModel);
    }

    if (didActivate) {
      didGoBelow = false;
      _currentInView = FolderWords(
        folder,
        _activeFoldersState.getActiveFolder(folderModel)!
      );
    }

    return didActivate;
  }


  ///Activate the buffer folder and shift the view to it.
  Future<bool> activateBufferFolder() async {
    bool didActivateBuffer = _activeFoldersState.activateBufferFolder();

    if (didActivateBuffer) {
      didGoBelow = false;
      _currentInView = FolderWords(
        _activeFoldersState.getBufferFolder!,
        _activeFoldersState.getBufferActiveFolder!
      );
    }

    return didActivateBuffer;
  }


  ///Deactivate a folder.
  ///Shift the view to a folder below by default. If there is no folder below,
  ///then shift the view to an upper folder.
  bool deactivateFolder(FolderContent folder) {
    final folderModel = FolderMapper.toFolderModel(folder);
    FolderContent? below = _activeFoldersState.getFolderBelow(folderModel); 
    FolderContent? above = _activeFoldersState.getFolderAbove(folderModel);

    bool didDeactivate = _activeFoldersState.deactivateFolder(folderModel);

    if (didDeactivate) {
      if (below != null) {
        didGoBelow = true;
        _currentInView = FolderWords(
          below,
          _activeFoldersState.getActiveFolder(FolderMapper.toFolderModel(below))!
        );
      } else if (above != null) {
        didGoBelow = false;
        _currentInView = FolderWords(
          above,
          _activeFoldersState.getActiveFolder(FolderMapper.toFolderModel(above))!
        );
      } else { _currentInView = null; }
    }

    return didDeactivate;
  }


  ///Extarct the buffer folder from the DB.
  Future<void> setBufferFolder() async {
    FolderContent bufferFolder = await _folderRepo.getBuffer();
    List<WordContent> bufferWords = await _wordRepo.getWordsOfFolder(bufferFolder);

    _activeFoldersState.setBufferFolder(
      FolderMapper.toFolderModel(bufferFolder),
      bufferWords.map((word) => WordMapper.toWordModel(word)).toList()
    );
  }


  ///Is folder in the active folders list?
  bool isFolderActive(FolderContent folder) {
    return _activeFoldersState.isFolderActive(FolderMapper.toFolderModel(folder));
  }


  ///Try to shift the view to the active folder above.
  ///Shift only if there is a folder above.
  bool shiftCurrentActiveFolderUp(FolderContent folder) {
    FolderContent? above = _activeFoldersState.getFolderAbove(FolderMapper.toFolderModel(folder));

    if (above != null) {
      didGoBelow = false;
      _currentInView = FolderWords(
        above,
        _activeFoldersState.getActiveFolder(FolderMapper.toFolderModel(above))!
      );
      return true;
    }

    return false;
  }


  ///Try to shift the view to the active folder below.
  ///Shift only if there is a folder below.
  bool shiftCurrentActiveFolderDown(FolderContent folder) {
    FolderContent? below = _activeFoldersState.getFolderBelow(FolderMapper.toFolderModel(folder));
    
    if (below != null) {
      didGoBelow = true;
      _currentInView = FolderWords(
        below,
        _activeFoldersState.getActiveFolder(FolderMapper.toFolderModel(below))!
      );
      return true;
    }

    return false;
  }

  
  //Getters
  ///Get the currently active folder.
  ///If the last tracked folder is no longer active (due to delete perhaps)
  ///then return the active folder at the top of the stack.
  ///Else return the last tracked active folder.
  ///
  ///Note that _currentInView simply points to one of the folders in active
  ///words list which is located in the core. Thus, if the active folder in
  ///the core is updated (e.g., a word is added or removed) the _currentInView
  ///will reflect those changes
  FolderWords? get currentActiveFolder {
    if (_currentInView != null && !isFolderActive(_currentInView!.folder)) {
      FolderContent? newFolder = _activeFoldersState.getTopFolder;

      if (newFolder != null) {
        _currentInView = FolderWords(
          newFolder,
          _activeFoldersState.getActiveFolder(FolderMapper.toFolderModel(newFolder))!
        );
      } else { _currentInView = null; }
    }

    return _currentInView;
  }


  ///GETTERS
  FolderContent? get bufferFolder => _activeFoldersState.getBufferFolder;
}