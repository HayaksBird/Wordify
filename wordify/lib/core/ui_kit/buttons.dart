import 'package:flutter/material.dart';
import 'package:wordify/features/word_tree/domain/entities/folder.dart';

///
class WordifyFloatingActionButton extends FloatingActionButton {
  const WordifyFloatingActionButton({
    super.key,
    required VoidCallback super.onPressed,
    required String tooltip
  }) : super(
        child: const Icon(Icons.add),
        tooltip: tooltip,
      );
}


///
class WordifyElevatedButton extends ElevatedButton {
  WordifyElevatedButton({
    super.key,
    required VoidCallback super.onPressed,
    required String text,
  }) : super(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text),
      );
}


///
class WordifyTextButton extends TextButton {
  WordifyTextButton({
    super.key,
    required VoidCallback super.onPressed,
    required String text,
  }) : super(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(text),
      );
}


///
class ChooseItemButton extends DropdownButton<Folder> {
  ChooseItemButton({
    super.key,
    required List<Folder> items,
    Folder? selectedItem,
    required ValueChanged<Folder?> super.onChanged,
  }) : super(
        hint: const Text("Select a Folder"),
        value: selectedItem,
        items: items.map<DropdownMenuItem<Folder>>((Folder folder) {
          return DropdownMenuItem<Folder>(
            value: folder,
            child: Text(folder.name),
          );
        }).toList(),
      );
}