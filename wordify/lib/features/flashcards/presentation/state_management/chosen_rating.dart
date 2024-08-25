import 'package:flutter/material.dart';

class ChosenRatingProvider extends InheritedNotifier<ValueNotifier<int>> {
  const ChosenRatingProvider({super.key, required super.child, required ValueNotifier<int> super.notifier});


  static ValueNotifier<int> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChosenRatingProvider>()!.notifier!;
  } 
}