import 'package:flutter/material.dart';

///An InheritedWidget that will contain the rating chosen for the word by user.
class FlipCardProvider extends InheritedNotifier<ValueNotifier<bool>> {
  const FlipCardProvider({super.key, required super.child, required ValueNotifier<bool> super.notifier});


  static ValueNotifier<bool> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FlipCardProvider>()!.notifier!;
  } 
}