import 'package:flutter/material.dart';
import 'package:wordify/core/domain/entities/folder.dart';

class ParentFolderProvider extends InheritedNotifier<ValueNotifier<FolderContent?>> {
  const ParentFolderProvider({super.key, required super.child, required ValueNotifier<FolderContent?> super.notifier});

  static ValueNotifier<FolderContent?> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ParentFolderProvider>()!.notifier!;
  } 
}