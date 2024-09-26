import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/folder.dart';

///An InheritedWidget that will contain the parent folder (when adding/updating a folder).
class ParentFolderProvider extends InheritedNotifier<ValueNotifier<FolderContent?>> {
  const ParentFolderProvider({super.key, required super.child, required ValueNotifier<FolderContent?> super.notifier});

  static ValueNotifier<FolderContent?> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ParentFolderProvider>()!.notifier!;
  } 
}