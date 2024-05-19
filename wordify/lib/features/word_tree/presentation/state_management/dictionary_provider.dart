import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/domain/entities/data_layer.dart';


///Used to pass down the tree an instance of Dictionary.
///Uses a notifier to update depended widgets when the value of the notifier(Dictionary)
///changes.
class DictionaryProvider extends InheritedNotifier<ValueNotifier<Dictionary>> {
  const DictionaryProvider({super.key, required super.child, required ValueNotifier<Dictionary> super.notifier});


  ///Return a ValueNotifier<Plan> from a nearest DictionaryProvider widget in the tree.
  static ValueNotifier<Dictionary> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DictionaryProvider>()!.notifier!;
  }
}