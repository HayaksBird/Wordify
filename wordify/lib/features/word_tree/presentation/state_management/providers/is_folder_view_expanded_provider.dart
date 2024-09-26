import 'package:flutter/material.dart';

///An InheritedWidget that will contain a boolean value which shows if the folder view is expanded
///or not.
class IsFolderViewExpandedProvider extends InheritedNotifier<ValueNotifier<bool>> {
  const IsFolderViewExpandedProvider({super.key, required super.child, required ValueNotifier<bool> super.notifier});


  static ValueNotifier<bool> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<IsFolderViewExpandedProvider>()!.notifier!;
  } 
}