import 'package:wordify/features/word_tree/presentation/state_management/validation_bloc/folder_bloc.dart';
import 'package:wordify/features/word_tree/presentation/state_management/validation_bloc/word_bloc.dart';


class ValidationBloc {
  static final ValidationBloc _instance = ValidationBloc._internal();
  
  late final FolderBloc folder;
  late final WordBloc word;


  factory ValidationBloc() {
    return _instance;
  }


  ValidationBloc._internal() {
    folder = FolderBloc();
    word = WordBloc();
  }
}