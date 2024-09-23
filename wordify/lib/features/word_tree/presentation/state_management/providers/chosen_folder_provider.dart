import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/folder.dart';

///An InheritedWidget that will contain the currently chosen folder by the user.
class ChosenFolderProvider extends InheritedNotifier<ValueNotifier<FolderContent?>> {
  const ChosenFolderProvider({super.key, required super.child, required ValueNotifier<FolderContent?> super.notifier});


  static ValueNotifier<FolderContent?> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChosenFolderProvider>()!.notifier!;
  } 
}