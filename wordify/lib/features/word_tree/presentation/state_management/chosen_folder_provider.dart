import 'package:flutter/material.dart';
import 'package:wordify/core/util/n_tree.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///
class ChosenFolderProvider extends InheritedNotifier<ValueNotifier<NTreeNode<Folder>?>> {
  const ChosenFolderProvider({super.key, required super.child, required ValueNotifier<NTreeNode<Folder>?> super.notifier});


  static ValueNotifier<NTreeNode<Folder>?> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChosenFolderProvider>()!.notifier!;
  } 
}