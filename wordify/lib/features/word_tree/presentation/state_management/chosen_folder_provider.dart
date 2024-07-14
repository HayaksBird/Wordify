import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///An InheritedWidget that will contain the currently chosen folder by the user.
class ChosenFolderProvider extends InheritedNotifier<ValueNotifier<Folder?>> {
  const ChosenFolderProvider({super.key, required super.child, required ValueNotifier<Folder?> super.notifier});


  static ValueNotifier<Folder?> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChosenFolderProvider>()!.notifier!;
  } 
}